package ${configs.packageName}.ui.base

import androidx.lifecycle.*
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.data.common.pagination.paged.ListListing
import ${configs.packageName}.data.common.pagination.paged.Listing
import ${configs.packageName}.ui.base.adapter.IPagedListAdapter

open class BasePagedViewModel<T> : ViewModel() {

    enum class Observers { INITIAL, STATE, LIST }

    var isLastPage = false

    val results: MediatorLiveData<Listing<T>> = MediatorLiveData()
    lateinit var networkState: LiveData<NetworkState>
    lateinit var initialLoading: LiveData<NetworkState>
    lateinit var typedList: LiveData<MutableList<Any>?>

    fun resetStates() {
        networkState = Transformations.switchMap(results) { dataSource -> dataSource.networkState }
        initialLoading = Transformations.switchMap(results) { dataSource -> dataSource.initialState }
        typedList = Transformations.switchMap(results as MediatorLiveData<ListListing<Any>>) { dataSource -> dataSource.list }
    }

    fun loadMore() {
        (results.value as ListListing<T>).loadNext()
    }

    fun refresh() {
        (results.value as ListListing<T>).refresh()
    }

    fun retry() {
        (results.value as ListListing<T>).retry()
    }

    open fun setPagedObserver(owner: LifecycleOwner, vararg adapters: IPagedListAdapter, callback: (Observers, NetworkState?) -> Unit = { _, _ -> }) {
        typedList.observe(owner, {
            it?.let {
                adapters.forEach { adapter ->
                    adapter.setPagedList(it)
                }
            }
            callback(Observers.LIST, null)
        })
        networkState.observe(owner, { state ->
            isLastPage = state.isEnd
            adapters.forEach { adapter ->
                adapter.setNetworkState(state)
            }
            callback(Observers.STATE, state)
        })
        initialLoading.observe(owner, { state ->
            adapters.forEach { adapter ->
                adapter.setNetworkState(state)
            }
            callback(Observers.INITIAL, state)
        })
    }


}