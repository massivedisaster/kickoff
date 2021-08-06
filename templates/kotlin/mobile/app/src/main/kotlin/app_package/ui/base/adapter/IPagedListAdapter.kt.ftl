package ${configs.packageName}.ui.base.adapter

import ${configs.packageName}.data.common.NetworkState

interface IPagedListAdapter {

    fun setNetworkState(newNetworkState: NetworkState?)

    fun setPagedList(pagedObjects: MutableList<*>)

    fun canLoad() : Boolean

    fun canLoad(hasConnection: Boolean) : Boolean
}