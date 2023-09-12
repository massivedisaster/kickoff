package ${configs.packageName}.ui.base.adapter.paged

import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.ui.base.adapter.BaseAdapter
import ${configs.packageName}.ui.base.adapter.BaseDiffCallback
import ${configs.packageName}.ui.base.adapter.BaseViewHolder
import ${configs.packageName}.ui.base.adapter.ClickType
import ${configs.packageName}.ui.base.adapter.state.StateCard
import ${configs.packageName}.ui.base.adapter.state.StateCardViews
import kotlin.reflect.KClass

abstract class BasePagedAdapter<T : Any, D : Any, VB : ViewDataBinding, VH : BaseViewHolder<T, D, VB>, C : BaseDiffCallback<T>>(
    viewHolderClass: KClass<VH>,
    itemClass: KClass<T>,
    clickListener: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: D, type: Enum<*>) -> Unit = { _, _, _, _ -> },
    errorClickListener: (ClickType, StateCard) -> Unit = { _, _ -> },
    errorViews: (emptyViews: StateCardViews, errorViews: StateCardViews, state: NetworkState?) -> Unit = { _, _, _ -> },
    onNewList: (previousList: List<Any>, currentList: List<Any>) -> Unit = { _, _ -> },
    recyclerView: RecyclerView? = null
) : BaseAdapter<T, D, VB, VH, C>(viewHolderClass, itemClass, clickListener, errorClickListener, errorViews, onNewList, recyclerView), IPagedListAdapter {

    private var networkState: NetworkState? = null

    override fun setPagedList(pagedObjects: MutableList<*>) {
        //for initial state, to avoid list from starting at bottom of first page
        if(pagedObjects.isNotEmpty() && itemCount == 1){
            notifyItemRemoved(itemCount - 1)
        }
        super.setList(pagedObjects)
    }

    override fun genericStateCard(position: Int): StateCard? {
        var card: StateCard? = null
        networkState?.let {
            card = StateCard(it.isLoading, it.isEmpty, it.isFailed, state = it)
        }
        return card
    }

    protected fun hasExtraRow() = differ.currentList.size >= 0 && networkState != null && (networkState!!.isLoading || networkState!!.isFailed || networkState!!.isEmpty)

    override fun canLoad() = differ.currentList.size > 0 && networkState != null && !networkState!!.isLoading && (networkState!!.isFailed || networkState!!.isSuccess)

    override fun canLoad(hasConnection: Boolean) = differ.currentList.size > 0 && networkState != null && !networkState!!.isLoading && ((networkState!!.isFailed && hasConnection) || networkState!!.isSuccess)

    override fun getItemViewType(position: Int) = if (hasExtraRow() && position == itemCount - 1) {
        if (differ.currentList.size == 0) {
            GENERIC_TYPE_EMPTY
        } else {
            GENERIC_TYPE
        }
    } else {
        super.getItemViewType(position)
    }

    override fun getItemCount() = differ.currentList.size + if (hasExtraRow()) 1 else 0

    override fun setNetworkState(newNetworkState: NetworkState?) {
        val hadExtraRow = hasExtraRow()
        this.networkState = newNetworkState
        val hasExtraRow = hasExtraRow()
        if (hadExtraRow != hasExtraRow) {
            if (hadExtraRow) {
                notifyItemRemoved(itemCount)
            } else {
                notifyItemInserted(itemCount - 1)
            }
        } else {
            notifyItemChanged(itemCount - 1)
        }
    }

}