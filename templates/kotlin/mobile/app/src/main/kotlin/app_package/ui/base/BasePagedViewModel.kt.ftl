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
import kotlin.collections.set

open class BasePagedViewModel : ViewModel() {

    enum class Observers { INITIAL, STATE, LIST }

    companion object {
        const val KEY_LIST = "KEY_LIST"
    }

    var isLastPage: MutableMap<String, Boolean> = mutableMapOf()
    var results: MutableMap<String, MediatorLiveData<Listing<*, *>>> = mutableMapOf()
    var networkState: MutableMap<String, LiveData<NetworkState>> = mutableMapOf()
    var initialLoading: MutableMap<String, LiveData<NetworkState>> = mutableMapOf()
    var typedList: MutableMap<String, LiveData<MutableList<Any>?>> = mutableMapOf()
    var meta: MutableMap<String, LiveData<Any>> = mutableMapOf()

    fun resetStates(key: String = KEY_LIST) {
        results[key] = MediatorLiveData()
        networkState[key] = Transformations.switchMap(results[key]!!) { dataSource -> dataSource.networkState }
        initialLoading[key] = Transformations.switchMap(results[key]!!) { dataSource -> dataSource.initialState }
        typedList[key] = Transformations.switchMap(results[key]!! as MediatorLiveData<ListListing<Any, Any>>) { dataSource -> dataSource.list }
        meta[key] = Transformations.switchMap(results[key]!! as MediatorLiveData<ListListing<Any, Any>>) { dataSource -> dataSource.meta }
    }

    fun isLastPage(key: String = KEY_LIST) = isLastPage[key] ?: false

    fun loadMore(key: String = KEY_LIST) {
        (results[key]?.value as ListListing<*, *>?)?.loadNext?.invoke()
    }

    fun refresh(key: String = KEY_LIST) {
        (results[key]?.value as ListListing<*, *>?)?.refresh?.invoke()
    }

    fun retry(key: String = KEY_LIST) {
        (results[key]?.value as ListListing<*, *>?)?.retry?.invoke()
    }

    open fun transform(any: Any) = any

    open fun setPagedObserver(owner: LifecycleOwner, vararg adapters: IPagedListAdapter, key: String = KEY_LIST, callback: (Observers, NetworkState?) -> Unit = { _, _ -> }) {
        typedList[key]?.observe(owner) {
            it?.let {
                adapters.forEach { adapter ->
                    adapter.setPagedList(it.map { obj -> transform(obj) }.toMutableList())
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