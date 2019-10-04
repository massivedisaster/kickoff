package ${configs.packageName}.data.common

import androidx.annotation.MainThread
import androidx.annotation.WorkerThread
import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.paging.PageKeyedDataSource
import ${configs.packageName}.network.models.ApiErrorResponse
import ${configs.packageName}.network.models.ApiResponse
import ${configs.packageName}.network.models.ApiSuccessResponse
import ${configs.packageName}.utils.helper.AppExecutors

abstract class DataSourceBoundResource<ItemType, ResultType>(
        private val offset: Int,
        private val appExecutors: AppExecutors
) : PageKeyedDataSource<Int, ResultType>() {

    companion object {
        private val TAG = DataSourceBoundResource::class.java.simpleName
    }

    var retry: (() -> Any)? = null
    val network = MediatorLiveData<NetworkState>()
    val initial = MediatorLiveData<NetworkState>()

    override fun loadInitial(params: LoadInitialParams<Int>, callback: LoadInitialCallback<Int, ResultType>) { }

    override fun loadBefore(params: LoadParams<Int>, callback: LoadCallback<Int, ResultType>) {
        // ignored, since we only ever append to our initial load
    }

    override fun loadAfter(params: LoadParams<Int>, callback: LoadCallback<Int, ResultType>) { }

    fun retryAllFailed() {
        val prevRetry = retry
        retry = null
        prevRetry?.let { retry ->
            appExecutors.getDiskIO().execute { retry() }
        }
    }

    protected fun postInitialState(state: NetworkState) {
        network.postValue(state)
        initial.postValue(state)
    }

    fun postAfterState(state: NetworkState) {
        network.postValue(state)
    }

    @WorkerThread
    protected open fun processResponse(response: ApiSuccessResponse<MutableList<ItemType>>) = response.body

    @MainThread
    protected abstract fun createCall(page: Int, pageSize: Int): LiveData<ApiResponse<MutableList<ItemType>>>

}