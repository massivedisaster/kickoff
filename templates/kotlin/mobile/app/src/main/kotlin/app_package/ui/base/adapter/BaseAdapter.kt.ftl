package ${configs.packageName}.ui.base

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.R
import kotlin.reflect.KClass

abstract class BaseAdapter<T : Any, VH : BaseViewHolder<T>, C : BaseDiffCallback<T>>(
        private val viewHolderClass: KClass<VH>,
        private val itemClass: KClass<T>,
        private val genericCardClickListener: (GenericStateCard.ClickType, GenericStateCard) -> Unit = { _, _ -> },
        private val clickListener: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: T, type: Enum<*>) -> Unit = { _, _, _, _ -> }
): RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    companion object {
        const val GENERIC_TYPE = 0
        const val GENERIC_TYPE_EMPTY = 1
        const val ITEM_TYPE = 2
    }

    private inline fun getViewHolder(itemView: View) = viewHolderClass.constructors.first().call(itemView)
    abstract val adapterDiff: C
    @get:LayoutRes abstract val itemLayout: Int
    internal val mDiffer = AsyncListDiffer(this, adapterDiff)

    open fun genericStateCard(position: Int) = mDiffer.currentList[position] as GenericStateCard

    fun setList(list: List<Any>) {
        mDiffer.submitList(ArrayList(list)) //creating a new list avoids problems
    }

    override fun getItemCount() = mDiffer.currentList.size

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = when (viewType) {
        ITEM_TYPE -> getViewHolder(LayoutInflater.from(parent.context).inflate(itemLayout, parent, false))
        GENERIC_TYPE -> GenericStateCardViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_generic_view_state, parent, false))
        else -> GenericStateCardFullHeightViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_generic_view_state_full_height, parent, false))
    }

    internal fun relayClickListener(index: Int, obj: T, type: Enum<*>) {
        clickListener(this, index, obj, type)
    }

    override fun getItemViewType(position: Int) = if (itemClass.isInstance(mDiffer.currentList[position])) {
        ITEM_TYPE
    } else {
        GENERIC_TYPE_EMPTY
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder.itemViewType) {
            ITEM_TYPE -> {
                val item = mDiffer.currentList[position] as T
                (holder as VH).bind(position, item, ::relayClickListener)
            }
            GENERIC_TYPE, GENERIC_TYPE_EMPTY -> {
                when (holder.itemViewType) {
                    GENERIC_TYPE -> (holder as GenericStateCardViewHolder).bind(holder, genericStateCard(position), genericCardClickListener)
                    GENERIC_TYPE_EMPTY -> (holder as GenericStateCardFullHeightViewHolder).bind(holder, genericStateCard(position), genericCardClickListener, R.string.generic_object_text)
                }
            }
        }
    }

}