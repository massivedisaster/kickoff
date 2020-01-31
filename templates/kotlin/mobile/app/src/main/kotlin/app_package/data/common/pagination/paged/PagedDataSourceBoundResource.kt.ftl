package ${configs.packageName}.data.common.pagination.paged

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import androidx.lifecycle.MediatorLiveData
import androidx.paging.PageKeyedDataSource
import ${configs.packageName}.data.common.CallResult
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.data.common.ServerErrors
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.utils.helper.AppExecutors

abstract class PagedDataSourceBoundResource<PaginationType, ResultType>(
        private val appExecutors: AppExecutors,
        private val usePaging: Boolean
) : PageKeyedDataSource<Int, ResultType>() {

    var retry: (() -> Any)? = null
    var loadnext: (() -> Any)? = null
    val networkData = MediatorLiveData<MutableList<ResultType>>()
    val network = MediatorLiveData<NetworkState>()
    val initial = MediatorLiveData<NetworkState>()

    override fun loadInitial(params: LoadInitialParams<Int>, callback: LoadInitialCallback<Int, ResultType>) {
        loadInit(params, callback)
    }

    override fun loadBefore(params: LoadParams<Int>, callback: LoadCallback<Int, ResultType>) {
        // ignored, since we only ever append to our initial load
    }

    override fun loadAfter(params: LoadParams<Int>, callback: LoadCallback<Int, ResultType>) {
        loadNext(params, callback)
    }


    fun loadInit(params: LoadInitialParams<Int>, callback: LoadInitialCallback<Int, ResultType>?) {
        postInitialState(NetworkState.LOADING)
        appExecutors.getNetworkIO().execute {
            val currentPage = initialPage()
            val nextPage = currentPage + 1

            val apiResponse = createCall(currentPage, params.requestedLoadSize)

            when (apiResponse.status.status) {
                NetworkState.Status.SUCCESS -> {

                    val responseBody = processResponse(apiResponse)
                    retry = null
                    val nextKey = calculateNextKey(responseBody!!, nextPage)

                    if (usePaging) {
                        appExecutors.getMainThread().execute {
                            callback?.onResult(identifyResponseList(responseBody), null, nextKey)
                        }
                    } else {
                        loadnext = nextKey?.let { { loadNext(LoadParams<Int>(nextKey, params.requestedLoadSize), null) } }
                        postInitialState(identifyResponseList(responseBody), null, nextKey)
                        if (nextKey == null) {
                            if(identifyResponseList(responseBody).isNullOrEmpty()) {
                                postInitialState(NetworkState.EMPTY)
                            } else {
                                postInitialState(NetworkState.NO_MORE)
                            }
                        } else {
                            postInitialState(NetworkState.SUCCESS)
                        }
                    }

                }
                NetworkState.Status.FAILED -> {
                    retry = { loadInit(params, callback) }
                    postInitialState(NetworkState.error(ApiErrorResponse<PaginationType>("", apiResponse.code, apiResponse.message ?: "", apiResponse.status.error?.serverError ?: ServerErrors.GENERAL)))
                }
                else -> {
                }
            }
        }
    }


    private fun loadNext(params: LoadParams<Int>, callback: LoadCallback<Int, ResultType>?) {
        postAfterState(NetworkState.LOADING)
        appExecutors.getNetworkIO().execute {
            val currentPage = params.key
            val nextPage = currentPage + 1

            val apiResponse = createCall(currentPage, params.requestedLoadSize)

            when (apiResponse.status.status) {
                NetworkState.Status.SUCCESS -> {
                    val responseBody = processResponse(apiResponse)
                    retry = null
                    val nextKey = calculateNextKey(responseBody!!, nextPage)

                    if (usePaging) {
                        appExecutors.getMainThread().execute {
                            callback?.onResult(identifyResponseList(responseBody), nextKey)
                        }
                    } else {
                        loadnext = nextKey?.let { { loadNext(LoadParams(nextKey, params.requestedLoadSize), null) } }
                        postAfterState(identifyResponseList(responseBody), nextKey)
                        if (nextKey == null) {
                            postAfterState(NetworkState.NO_MORE)
                        } else {
                            postAfterState(NetworkState.SUCCESS)
                        }
                    }
                }
                NetworkState.Status.FAILED -> {
                    retry = { loadNext(params, callback) }
                    postInitialState(NetworkState.error(ApiErrorResponse<PaginationType>("", apiResponse.code, apiResponse.message
                            ?: "", apiResponse.status.error?.serverError ?: ServerErrors.GENERAL)))
                }
                else -> {
                }
            }
        }
    }

    fun retryAllFailed() {
        val prevRetry = retry
        retry = null
        prevRetry?.let { retry ->
            appExecutors.getNetworkIO().execute { retry() }
        }
    }

    //LIST LISTING
    private fun postInitialState(content: List<ResultType>, previousKey: Int?, nextKey: Int?) {
        val list: MutableList<ResultType> = mutableListOf()
        list.addAll(content)
        appExecutors.getMainThread().execute {
            networkData.value = list
        }
    }

    private fun postAfterState(content: List<ResultType>, nextKey: Int?) {
        val list = networkData.value
        list?.addAll(content)
        appExecutors.getMainThread().execute {
            networkData.value = list
        }
    }

    open fun loadNext() {
        loadnext?.invoke()
    }

    open fun listListingInvalidate() {
        appExecutors.getMainThread().execute {
            networkData.value = mutableListOf()
            networkData.postValue(networkData.value)
        }
        loadInit(LoadInitialParams(initialPage(), false), null)
    }


    //PAGED LISTING
    private fun postInitialState(state: NetworkState) {
        appExecutors.getMainThread().execute {
            network.value = state
            initial.value = state
        }
    }

    private fun postAfterState(state: NetworkState) {
        appExecutors.getMainThread().execute {
            network.value = state
        }
    }

    @WorkerThread
    protected open fun processResponse(response: CallResult<PaginationType>) = response.data

    @MainThread
    protected abstract fun createCall(innerPage: Int, pageSize: Int): CallResult<PaginationType>

    protected abstract fun calculateNextKey(response: PaginationType, nextPage: Int): Int?

    protected abstract fun identifyResponseList(response: PaginationType): List<ResultType>

    protected abstract fun initialPage(): Int
}
