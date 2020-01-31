package ${configs.packageName}.ui.base.adapter

import androidx.recyclerview.widget.RecyclerView
import  ${configs.packageName}.data.common.NetworkState
import kotlin.reflect.KClass

abstract class BasePagedAdapter<T : Any, VH : BaseViewHolder<T>, C : BaseDiffCallback<T>>(
        viewHolderClass: KClass<VH>,
        private val itemClass: KClass<T>,
        private val genericCardClickListener: (GenericStateCard.ClickType, GenericStateCard) -> Unit = { _, _ -> },
        clickListener: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: T, type: Enum<*>) -> Unit = { _, _, _, _ -> }
) : BaseAdapter<T, VH, C>(viewHolderClass, itemClass, genericCardClickListener, clickListener), IPagedListAdapter<Any> {

    private var networkState: NetworkState? = null

    override fun setPagedList(pagedObjects: MutableList<Any>) {
        super.setList(pagedObjects)
    }

    override fun genericStateCard(position: Int): GenericStateCard {
        var card: GenericStateCard = super.genericStateCard(position)
        networkState?.let {
            card = GenericStateCard(it.isLoading, it.isEmpty, it.isFailed)
        }
        return card
    }

    private fun hasExtraRow() = mDiffer.currentList.size >= 0 && networkState != null && (networkState!!.isLoading || networkState!!.isFailed || networkState!!.isEmpty)

    override fun canLoad() = mDiffer.currentList.size > 0 && networkState != null && networkState!!.isLoading

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