package ${configs.packageName}.ui.base.adapter

import ${configs.packageName}.data.common.NetworkState

interface IPagedListAdapter<Type> {

    fun setNetworkState(newNetworkState: NetworkState?)

    fun setPagedList(pagedObjects: MutableList<Type>)

    fun canLoad() : Boolean

}