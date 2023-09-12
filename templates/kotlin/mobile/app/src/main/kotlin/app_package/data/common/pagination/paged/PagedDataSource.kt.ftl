package ${configs.packageName}.data.common.pagination.paged

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import androidx.lifecycle.MediatorLiveData
import ${configs.packageName}.data.common.CallResult
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.data.common.ServerError
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.utils.helper.AppExecutors

abstract class PagedDataSource<PaginationType, MetaType, ResultType: Any>(private val appExecutors: AppExecutors) {

    var retry: (() -> Any)? = null
    var loadnext: (() -> Any)? = null
    val networkData = MediatorLiveData<MutableList<ResultType>>()
    val network = MediatorLiveData<NetworkState>()
    val initial = MediatorLiveData<NetworkState>()
    val meta = MediatorLiveData<MetaType>()
    private var isLoading = false

    fun loadInitial(params: Pair<Int, Boolean>) {
        loadInit(params)
    }

    fun loadAfter(params: Pair<Int, Int>) {
        loadNext(params)
    }

    fun loadInit(params: Pair<Int, Boolean>) {
        postInitialState(NetworkState.LOADING)
        appExecutors.getNetworkIO().execute {
            val currentPage = initialPage()
            val nextPage = currentPage + 1

            val apiResponse = createCall(currentPage, params.first)

            when (apiResponse.status.status) {
                NetworkState.Status.SUCCESS -> {
                    val responseBody = processResponse(apiResponse)
                    retry = null
                    val nextKey = calculateNextKey(responseBody!!, nextPage)

                    loadnext = nextKey?.let { { loadNext(Pair(nextKey, params.first)) } }
                    postMeta(identifyMeta(responseBody))
                    postInitialState(identifyResponseList(responseBody))
                    if (nextKey == null) {
                        if (identifyResponseList(responseBody).isNullOrEmpty()) {
                            postInitialState(NetworkState.EMPTY)
                        } else {
                            postInitialState(NetworkState.NO_MORE)
                        }
                    } else {
                        postInitialState(NetworkState.SUCCESS)
                    }
                }
                NetworkState.Status.FAILED -> {
                    retry = { loadInit(params) }
                    postMeta(null)
                    postInitialState(NetworkState.error(ApiErrorResponse<PaginationType>("", apiResponse.code, apiResponse.message ?: "", apiResponse.status.error?.serverError ?: ServerError.GENERAL)))
                }
                else -> {}
            }
            isLoading = false
        }
    }

    private fun loadNext(params: Pair<Int, Int>) {
        postAfterState(NetworkState.LOADING)
        appExecutors.getNetworkIO().execute {
            val currentPage = params.first
            val nextPage = currentPage + 1

            val apiResponse = createCall(currentPage, params.second)

            when (apiResponse.status.status) {
                NetworkState.Status.SUCCESS -> {
                    val responseBody = processResponse(apiResponse)
                    retry = null
                    val nextKey = calculateNextKey(responseBody!!, nextPage)

                    loadnext = nextKey?.let { { loadNext(Pair(nextKey, params.second)) } }
                    postMeta(identifyMeta(responseBody))
                    postAfterState(identifyResponseList(responseBody))
                    if (nextKey == null) {
                        postAfterState(NetworkState.NO_MORE)
                    } else {
                        postAfterState(NetworkState.SUCCESS)
                    }
                }
                NetworkState.Status.FAILED -> {
                    retry = { loadNext(params) }
                    postInitialState(NetworkState.error(ApiErrorResponse<PaginationType>("", apiResponse.code, apiResponse.message ?: "", apiResponse.status.error?.serverError ?: ServerError.GENERAL)))
                }
                else -> {}
            }
            isLoading = false
        }
    }

    fun retryAllFailed() {
        val prevRetry = retry
        retry = null
        prevRetry?.let { retry -> appExecutors.getNetworkIO().execute { retry() } }
    }

    //LIST LISTING
    private fun postInitialState(content: List<ResultType>?) {
        val list: MutableList<ResultType> = mutableListOf()
        list.addAll(content ?: listOf())
        appExecutors.getMainThread().execute {
            networkData.value = list
        }
    }

    private fun postAfterState(content: List<ResultType>?) {
        val list = networkData.value ?: mutableListOf()
        if (!allowDuplicates()) {
            val temp = mutableListOf<ResultType>()
            temp.addAll(content ?: listOf())
            content?.forEach { newObject ->
                if (list.any { duplicateComparator(it, newObject) }) {
                    temp.remove(newObject)
                }
            }
            list.addAll(temp)
        } else {
            list.addAll(content ?: listOf())
        }
        appExecutors.getMainThread().execute {
            networkData.value = list
        }
    }

    open fun loadNext() {
        if (!isLoading) {
            isLoading = true
            loadnext?.invoke()
        }
    }

    open fun listListingInvalidate() {
        appExecutors.getMainThread().execute {
            networkData.postValue(mutableListOf())
        }
        loadInit(Pair(initialPage(), false))
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

    private fun postMeta(obj: MetaType?) {
        obj?.let {
            appExecutors.getMainThread().execute {
                meta.value = it
            }
        }
    }

    @WorkerThread
    protected open fun processResponse(response: CallResult<PaginationType>) = response.data

    @MainThread
    protected abstract fun createCall(innerPage: Int, pageSize: Int): CallResult<PaginationType>

    protected abstract fun calculateNextKey(response: PaginationType, nextPage: Int): Int?

    protected abstract fun identifyResponseList(response: PaginationType): List<ResultType>?

    protected abstract fun identifyMeta(response: PaginationType): MetaType?

    protected abstract fun initialPage(): Int

    protected abstract fun allowDuplicates(): Boolean

    protected abstract fun duplicateComparator(oldObject: ResultType, newObject: ResultType): Boolean
}
