package ${configs.packageName}.data.common

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.Observer
import ${configs.packageName}.BuildConfig
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.network.models.ApiResponse
import ${configs.packageName}.network.models.ApiSuccessResponse
import ${configs.packageName}.utils.authentication.AccountUtils
import ${configs.packageName}.utils.helper.AppExecutors

abstract class NetworkBoundResource<ResultType, RequestType, RefreshType> @MainThread constructor(private val appExecutors: AppExecutors,
                                                                                     private val accountUtils: AccountUtils) {

    enum class Type { NETWORK, DATABASE, BOTH }

    private val result = LiveDataWrapper<ResultType>()
    private var network = MediatorLiveData<RequestType>()
    private val refresh = MediatorLiveData<CallResult<RefreshType>>()

    private var refreshCall: LiveData<ApiResponse<RefreshType>>? = null
    private var requestType: Type = Type.NETWORK

    private val refreshObserver: Observer<ApiResponse<RefreshType>> by lazy {
        RefreshObserver()
    }

    init {
        setValue(CallResult.loading(connection = this))
    }

    fun network() {
        requestType = Type.NETWORK
        result.removeSource(network)
        network = MediatorLiveData()
        requestFromNetwork()
    }

    fun database() {
        requestType = Type.DATABASE
        val databaseSource = loadFromDatabase()
        if (databaseSource != null) {
            result.removeSource(network)
            result.addSource(databaseSource) { newData ->
                setValue(CallResult.success(200, newData, null, this))
            }
        }
    }

    fun dbAndNetwork() {
        requestType = Type.BOTH
        val databaseSource = loadFromDatabase()
        if (databaseSource != null) {
            result.addSource(databaseSource) { data ->
                result.removeSource(databaseSource)
                if (shouldRequestFromNetwork(data)) {
                    requestFromNetwork(true)
                } else {
                    result.addSource(databaseSource) { newData ->
                        setValue(CallResult.success(200, newData, null, this))
                    }
                }
            }
        }
    }

    fun retry() {
        when (requestType) {
            Type.NETWORK -> network()
            Type.DATABASE -> database()
            Type.BOTH -> dbAndNetwork()
        }
    }

    private fun requestFromNetwork(withDb: Boolean = false) {
        val apiResponse = createCall()

        setValue(CallResult.loading())

        result.addSource(apiResponse) { response ->
            result.removeSource(apiResponse)

            when (response) {
                is ApiSuccessResponse -> {
                    appExecutors.getDiskIO().execute {
                        val responseBody = processResponse(response)
                        saveCallResult(responseBody!!)
                        val databaseSource = loadFromDatabase()
                        if (withDb && databaseSource != null) {
                            appExecutors.getMainThread().execute {
                                result.addSource(databaseSource) { newData ->
                                    setValue(CallResult.success(200, newData, response.headers, this))
                                }
                            }
                        } else {
                            appExecutors.getMainThread().execute {
                                result.addSource(network) { newData ->
                                    setValue(CallResult.success(200, newData as ResultType, response.headers, this))
                                }

                                updateNetworkSource(responseBody)
                            }
                        }
                    }
                }
                is ApiErrorResponse -> {
                    appExecutors.getMainThread().execute {
                        refreshCall = refreshCall()
                        if (response.errorCode == 401 && refreshCall != null) {
                            if (accountUtils.refreshingToken.get()) {
                                appExecutors.getNetworkIO().execute {
                                    var i = BuildConfig.API_TIMEOUT //MUST BE IN SECONDS
                                    if (i > 100) {
                                        throw Exception("API_TIMEOUT must be in seconds and less than 100")
                                    }
                                    while (accountUtils.refreshingToken.get() && i > 0) {
                                        Thread.sleep(1000)
                                        i--
                                    }
                                    appExecutors.getMainThread().execute {
                                        requestFromNetwork()
                                    }
                                }
                            } else {
                                accountUtils.refreshingToken.set(true)
                                refresh.addSource(refreshCall!!) {
                                    refresh.removeSource(refreshCall!!)
                                }
                                refreshCall?.observeForever(refreshObserver)
                            }
                        } else {
                            result.addSource(network) { newData ->
                                setValue(CallResult.error(response.errorMessage, response.errorCode, newData as ResultType, response, this))
                            }

                            updateNetworkSource(null)
                        }
                    }
                }
            }
        }
    }

    fun asLiveData() = result

    @MainThread
    private fun setValue(newValue: CallResult<ResultType>) {
        if (result.value != newValue) {
            result.value = newValue
        }
    }

    @MainThread
    private fun updateNetworkSource(newValue: RequestType?) {
        network.value = newValue
    }

    @MainThread
    protected open fun refreshCall(): LiveData<ApiResponse<RefreshType>>? = null

    @MainThread
    protected open fun refreshResult(apiResponse: RefreshType?) { }

    @WorkerThread
    protected open fun processResponse(response: ApiSuccessResponse<RequestType>) = response.body

    @WorkerThread
    protected open fun saveCallResult(data: RequestType) { }

    @MainThread
    open fun loadFromDatabase(): LiveData<ResultType>? = null

    @MainThread
    protected open fun shouldRequestFromNetwork(data: ResultType?) = true

    @MainThread
    protected abstract fun createCall(): LiveData<ApiResponse<RequestType>>

    private inner class RefreshObserver : Observer<ApiResponse<RefreshType>> {
        override fun onChanged(response: ApiResponse<RefreshType>?) {
            accountUtils.refreshingToken.set(false)
            if (response is ApiSuccessResponse) {
                requestFromNetwork()
                refreshResult(response.body)
            }

            refreshCall?.removeObserver(this)
        }
    }

}
