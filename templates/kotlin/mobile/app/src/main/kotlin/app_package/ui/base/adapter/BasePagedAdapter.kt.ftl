package ${configs.packageName}.ui.base.adapter

import android.widget.TextView
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import  ${configs.packageName}.data.common.NetworkState
import kotlin.reflect.KClass

abstract class BasePagedAdapter<T : Any, VB : ViewDataBinding, VH : BaseViewHolder<T, VB>, C : BaseDiffCallback<T>>(
        viewHolderClass: KClass<VH>,
        private val itemClass: KClass<T>,
        private val genericCardClickListener: (ClickType, GenericStateCard) -> Unit = { _, _ -> },
        clickListener: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: T, type: Enum<*>) -> Unit = { _, _, _, _ -> },
        private val genericCardErrorListener: (emptyViews: GenericStateCardErrorViews, errorViews: GenericStateCardErrorViews, isFullHeight: Boolean, contextualObject : NetworkState?) -> Unit = {_, _, _, _ -> },
        private val onNewList: (previousList: List<Any>, currentList: List<Any>) -> Unit = { _, _ -> },
        private val recyclerView: RecyclerView? = null
) : BaseAdapter<T, VB, VH, C>(viewHolderClass, itemClass, genericCardClickListener, clickListener, genericCardErrorListener, onNewList, recyclerView), IPagedListAdapter {

    private var networkState: NetworkState? = null

    override fun setPagedList(pagedObjects: MutableList<*>) {
        //for initial state, to avoid list from starting at bottom of first page
        if(pagedObjects.isNotEmpty() && itemCount == 1){
            notifyItemRemoved(itemCount - 1)
        }
        super.setList(pagedObjects)
    }

    override fun setPagedList(pagedObjects: MutableList<*>, onReady: (previousList: List<Any>, currentList: List<Any>) -> Unit) {
        //for initial state, to avoid list from starting at bottom of first page
        if(pagedObjects.isNotEmpty() && itemCount == 1){
            notifyItemRemoved(itemCount - 1)
        }
        super.setList(pagedObjects, onReady)
    }

    override fun genericStateCard(position: Int): GenericStateCard? {
        var card: GenericStateCard? = null
        networkState?.let {
            card = GenericStateCard(it.isLoading, it.isEmpty, it.isFailed, networkState)
        }
        return card
    }

    private fun hasExtraRow() = mDiffer.currentList.size >= 0 && networkState != null && (networkState!!.isLoading || networkState!!.isFailed || networkState!!.isEmpty)

    override fun canLoad() = mDiffer.currentList.size > 0 && networkState != null && !networkState!!.isLoading && (networkState!!.isFailed || networkState!!.isSuccess)

    override fun canLoad(hasConnection: Boolean) = mDiffer.currentList.size > 0 && networkState != null && !networkState!!.isLoading && ((networkState!!.isFailed && hasConnection) || networkState!!.isSuccess)

    override fun getItemViewType(position: Int) = if (hasExtraRow() && position == itemCount - 1) {
        if (mDiffer.currentList.size == 0) {
            GENERIC_TYPE_EMPTY
        } else {
            GENERIC_TYPE
        }
    } else {
        super.getItemViewType(position)
    }

    override fun getItemCount() = mDiffer.currentList.size + if (hasExtraRow()) 1 else 0

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