package ${configs.packageName}.ui.base.adapter

import ${configs.packageName}.data.common.NetworkState

interface IPagedListAdapter {

    fun setNetworkState(newNetworkState: NetworkState?)

    fun setPagedList(pagedObjects: MutableList<*>)

    fun setPagedList(pagedObjects: MutableList<*>, onReady: (previousList: List<Any>, currentList: List<Any>) -> Unit = { _, _ -> })

    fun canLoad() : Boolean

    fun canLoad(hasConnection: Boolean) : Boolean
}