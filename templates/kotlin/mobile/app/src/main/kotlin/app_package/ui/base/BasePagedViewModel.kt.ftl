package ${configs.packageName}.ui.base

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.Transformations
import androidx.lifecycle.ViewModel
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.data.common.pagination.paged.ListListing
import ${configs.packageName}.data.common.pagination.paged.Listing
import ${configs.packageName}.ui.base.adapter.IPagedListAdapter

open class BasePagedViewModel : ViewModel() {

    enum class Observers { INITIAL, STATE, LIST }

    private var isLastPage: MutableMap<String, Boolean> = mutableMapOf()
    private var results: MutableMap<String, MediatorLiveData<Listing<*, *>>> = mutableMapOf()
    private var networkState: MutableMap<String, LiveData<NetworkState>> = mutableMapOf()
    private var initialLoading: MutableMap<String, LiveData<NetworkState>> = mutableMapOf()
    private var typedList: MutableMap<String, LiveData<MutableList<Any>?>> = mutableMapOf()
    private var meta: MutableMap<String, LiveData<Any>> = mutableMapOf()

    fun resetStates(key: String) {
        results[key] = MediatorLiveData()
        networkState[key] = Transformations.switchMap(results[key]!!) { dataSource -> dataSource.networkState }
        initialLoading[key] = Transformations.switchMap(results[key]!!) { dataSource -> dataSource.initialState }
        typedList[key] = Transformations.switchMap(results[key]!! as MediatorLiveData<ListListing<Any, Any>>) { dataSource -> dataSource.list }
        meta[key] = Transformations.switchMap(results[key]!! as MediatorLiveData<ListListing<Any, Any>>) { dataSource -> dataSource.meta }
    }

    fun isLastPage(key: String) = isLastPage[key] ?: false

    fun loadMore(key: String) {
        (results[key]?.value as ListListing<*, *>?)?.loadNext?.invoke()
    }

    fun refresh(key: String) {
        (results[key]?.value as ListListing<*, *>?)?.refresh?.invoke()
    }

    fun retry(key: String) {
        (results[key]?.value as ListListing<*, *>?)?.retry?.invoke()
    }

    open fun setPagedObserver(key: String, owner: LifecycleOwner, vararg adapters: IPagedListAdapter, callback: (Observers, NetworkState?) -> Unit = { _, _ -> }) {
        typedList[key]?.observe(owner) {
            it?.let {
                adapters.forEach { adapter ->
                    adapter.setPagedList(it)
                }
            }
            callback(Observers.LIST, null)
        }
        networkState[key]?.observe(owner) { state ->
            isLastPage[key] = state.isEnd
            adapters.forEach { adapter ->
                adapter.setNetworkState(state)
            }
            callback(Observers.STATE, state)
        }
        initialLoading[key]?.observe(owner) { state ->
            adapters.forEach { adapter ->
                adapter.setNetworkState(state)
            }
            callback(Observers.INITIAL, state)
        }
    }

}