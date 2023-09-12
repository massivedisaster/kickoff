package ${configs.packageName}.data.common

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import androidx.lifecycle.MediatorLiveData
import ${configs.packageName}.BuildConfig
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.network.models.ApiResponse
import ${configs.packageName}.network.models.ApiSuccessResponse
import ${configs.packageName}.utils.authentication.AccountUtils
import ${configs.packageName}.utils.helper.AppExecutors
import ${configs.packageName}.utils.helper.extensions.android.addValue
import kotlin.reflect.KFunction1

abstract class BoundResource<ResultType, RequestType, RefreshType>
@MainThread constructor(private val appExecutors: AppExecutors) {

    enum class Type { NETWORK, DATABASE, BOTH }

    val result = MediatorLiveData<CallResult<ResultType>>()
    private var requestType: Type = Type.NETWORK

    private var parameters: Array<out Any?> = arrayOf()
    @set:MainThread @get:MainThread lateinit var call: KFunction1<Array<out Any?>, ApiResponse<RequestType>>

    fun network(vararg params: Any?): CallResult<ResultType> {
        requestType = Type.NETWORK
        parameters = params
        return request()
    }

    fun database(vararg params: Any?): CallResult<ResultType> {
        requestType = Type.DATABASE
        parameters = params
        val newData = loadFromDatabase()
        return CallResult.success(200, newData, null)
    }

    fun dbAndNetwork(vararg params: Any?): CallResult<ResultType> {
        requestType = Type.BOTH
        parameters = params
        val data = loadFromDatabase()
        return if (shouldRequestFromNetwork(data)) {
            request(true)
        } else {
            CallResult.success(200, data, null)
        }
    }

    fun retry() {
        when (requestType) {
            Type.NETWORK -> network(parameters)
            Type.DATABASE -> database(parameters)
            Type.BOTH -> dbAndNetwork(parameters)
        }
    }

    fun networkAsync(vararg params: Any?) {
        requestType = Type.NETWORK
        parameters = params
        requestAsync()
    }

    fun databaseAsync(vararg params: Any?) {
        requestType = Type.DATABASE
        parameters = params
        result.addValue(CallResult.loading())
        appExecutors.getNetworkIO().execute {
            val response = loadFromDatabase()
            appExecutors.getMainThread().execute {
                result.addValue(CallResult.success(200, response, null))
            }
        }
    }

    fun dbAndNetworkAsync(vararg params: Any?) {
        requestType = Type.BOTH
        parameters = params
        result.addValue(CallResult.loading())
        appExecutors.getNetworkIO().execute {
            val response = loadFromDatabase()
            if (shouldRequestFromNetwork(response)) {
                val networkResponse = request(true)
                appExecutors.getMainThread().execute {
                    result.addValue(networkResponse)
                }
            } else {
                appExecutors.getMainThread().execute {
                    result.addValue(CallResult.success(200, response, null))
                }
            }
        }
    }

    fun retryAsync() {
        when (requestType) {
            Type.NETWORK -> networkAsync(parameters)
            Type.DATABASE -> databaseAsync(parameters)
            Type.BOTH -> dbAndNetworkAsync(parameters)
        }
    }

    private fun requestAsync(withDb: Boolean = false) {
        appExecutors.getMainThread().execute {
            result.addValue(CallResult.loading())
        }
        appExecutors.getNetworkIO().execute {
            val response = request(withDb)
            appExecutors.getMainThread().execute {
                result.addValue(response)
            }
        }
    }

    private fun request(withDb: Boolean = false): CallResult<ResultType> {
        when (val response = call(parameters)) {
            is ApiSuccessResponse -> {
                var responseBody = processResponse(response)
                saveCallResult(responseBody)
                if (withDb) {
                    responseBody = loadFromDatabase()
                }
                val callResult = CallResult.success(response.successCode, newData, response.headers, this)
                publishEndEvent(callResult)

                callResult
            }
            is ApiErrorResponse -> {
                if (response.errorCode == 401) {
                    if (AccountUtils.refreshingToken.compareAndSet(false, true)) {
                        refresh()
                    } else {
                        var i = BuildConfig.API_TIMEOUT //MUST BE IN SECONDS
                        while (AccountUtils.refreshingToken.get() && i > 0) {
                            Thread.sleep(1000)
                            i--
                        }
                        request()
                    }
                } else {
                    CallResult.error(response.errorMessage, response.errorCode, newData as ResultType, response, this)
                }
            }
        }
    }

    @MainThread
    protected open fun refreshCall(): ApiResponse<RefreshType>? = null

    @MainThread
    protected open fun refreshResult(apiResponse: RefreshType?) {}

    @MainThread
    protected open fun refreshError() {}

    @WorkerThread
    protected open fun processResponse(response: ApiSuccessResponse<RequestType>) = response.body as ResultType?

    @WorkerThread
    protected open fun processResponse(response: ApiErrorResponse<RequestType>) = response.errorMessage

    @WorkerThread
    protected open fun saveCallResult(data: RequestType?) {}

    @MainThread
    open fun loadFromDatabase(): ResultType? = null

    @MainThread
    protected open fun shouldRequestFromNetwork(data: ResultType?) = true

    @WorkerThread
    protected open fun publishEndEvent(data: CallResult<ResultType>) {}

    private fun refresh(): CallResult<ResultType> = when (val refreshResponse = refreshCall()) {
        is ApiSuccessResponse -> {
            refreshResult(response.body)
            AccountUtils.refreshingToken.set(false)
            request()
        }
        is ApiErrorResponse -> {
            refreshError()
            AccountUtils.refreshingToken.set(false)
            CallResult.error(response.errorMessage, response.errorCode, null, response)
        }
        else -> {
            AccountUtils.refreshingToken.set(false)
            CallResult.error("", -1, null, null)
        }
    }

}
