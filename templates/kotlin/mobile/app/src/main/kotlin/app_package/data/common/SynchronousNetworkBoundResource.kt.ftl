package ${configs.packageName}.data.common

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import ${configs.packageName}.BuildConfig
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.network.models.ApiResponse
import ${configs.packageName}.network.models.ApiSuccessResponse
import ${configs.packageName}.utils.authentication.AccountUtils

abstract class SynchronousNetworkBoundResource<ResultType, RefreshType>
@MainThread constructor(private val accountUtils: AccountUtils) {

    private var refreshCall: ApiResponse<RefreshType>? = null

    fun initCall(): CallResult<ResultType> {
        return requestFromNetwork()
    }

    private fun requestFromNetwork(): CallResult<ResultType> {

        when (val apiResponse = createCall()!!) {
            is ApiSuccessResponse -> {
                val responseBody = processResponse(apiResponse)
                val callResult = CallResult.success(apiResponse.successCode, responseBody, apiResponse.headers)
                saveCallResult(responseBody)
                publishEndEvent(callResult)

                return callResult

            }
            is ApiErrorResponse -> {
                if (apiResponse.errorCode == 401) {
                    return if (AccountUtils.refreshingToken.compareAndSet(false, true)) {
                        refresh()
                    } else {
                        var i = BuildConfig.API_TIMEOUT //MUST BE IN SECONDS
                        if (i > 100) {
                            throw Exception("API_TIMEOUT must be in seconds and less than 100")
                        }
                        while (AccountUtils.refreshingToken.get() && i > 0) {
                            Thread.sleep(1000)
                            i--
                        }
                        requestFromNetwork()
                    }
                } else {
                    return CallResult.error(processResponse(apiResponse), apiResponse.errorCode, null, apiResponse)
                }
            }
        }
    }

    @MainThread
    protected open fun refreshCall(): ApiResponse<RefreshType>? = null

    @MainThread
    protected open fun refreshResult(apiResponse: RefreshType?) { }

    @MainThread
    protected open fun refreshError() { }

    @WorkerThread
    protected open fun processResponse(response: ApiSuccessResponse<ResultType>) = response.body

    @WorkerThread
    protected open fun processResponse(response: ApiErrorResponse<ResultType>) = response.errorMessage

    @WorkerThread
    protected open fun saveCallResult(data: ResultType?) { }

    @MainThread
    protected open fun createCall(): ApiResponse<ResultType>? = null

    @MainThread
    protected open fun createCall(obj: Any): ApiResponse<ResultType>? = null

    @WorkerThread
    protected open fun publishEndEvent(data: CallResult<ResultType>) {}

    private fun refresh(): CallResult<ResultType> {

        return when (val refreshResponse = refreshCall()) {
            is ApiSuccessResponse -> {
                refreshResult(refreshResponse.body)
                AccountUtils.refreshingToken.set(false)
                requestFromNetwork()
            }
            is ApiErrorResponse -> {
                refreshError()
                AccountUtils.refreshingToken.set(false)
                CallResult.error(refreshResponse.errorMessage, refreshResponse.errorCode, null, refreshResponse)
            }
            else -> {
                AccountUtils.refreshingToken.set(false)
                CallResult.error("", -1, "")
            }
        }
    }

}
