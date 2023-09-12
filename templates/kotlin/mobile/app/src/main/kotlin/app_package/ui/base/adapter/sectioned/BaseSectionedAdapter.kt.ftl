package ${configs.packageName}.ui.base.adapter.sectioned

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.R
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.ui.base.adapter.BaseDiffCallback
import ${configs.packageName}.ui.base.adapter.BaseViewHolder
import ${configs.packageName}.ui.base.adapter.ClickType
import ${configs.packageName}.ui.base.adapter.state.StateCard
import ${configs.packageName}.ui.base.adapter.state.StateCardFullViewHolder
import ${configs.packageName}.ui.base.adapter.state.StateCardViewHolder
import ${configs.packageName}.ui.base.adapter.state.StateCardViews
import kotlin.reflect.KClass

abstract class BaseSectionedAdapter<Item : Any, Header : Any, D : Any, VS : ViewDataBinding, VI : ViewDataBinding, SH : BaseViewHolder<Header, D, VS>, VH : BaseViewHolder<Item, D, VI>, CI : BaseDiffCallback<Any>>(
    private val viewHolderClass: KClass<VH>,
    private val sectionHolderClass: KClass<SH>,
    private val itemClass: KClass<Item>,
    private val headerClass: KClass<Header>,
    private val clickListener: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: D, type: Enum<*>) -> Unit = { _, _, _, _ -> },
    private val errorClickListener: (ClickType, StateCard) -> Unit = { _, _ -> },
    private val errorViews: (emptyViews: StateCardViews, errorViews: StateCardViews, state: NetworkState?) -> Unit = { _, _, _ -> },
    private val onNewList: (previousList: List<Any>, currentList: List<Any>) -> Unit = { _, _ -> },
    private val recyclerView: RecyclerView? = null
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    companion object {
        const val GENERIC_TYPE = 0
        const val GENERIC_TYPE_EMPTY = 1
        const val HEADER_TYPE = 2
        const val ITEM_TYPE = 3
    }

    abstract val adapterDiff: CI

    @get:LayoutRes
    abstract val itemLayout: Int
    abstract val sectionLayout: Int
    internal val differ by lazy { AsyncListDiffer(this, adapterDiff) }

    fun setList(list: List<*>) {
        differ.submitList(ArrayList(list)) //creating a new list avoids problems
        differ.addListListener(onNewList)
    }

    /**
     * Create the header view holder.
     *
     * @param parent The ViewGroup into which the new View will be added after it is bound to an adapter position.
     * @param viewType The view type of the new View.
     *
     * @return A new header ViewHolder that holds a View of the given view type.
     */
    private fun onCreateSubHeaderViewHolder(itemView: View) = sectionHolderClass.constructors.first().call(itemView, this, recyclerView)

    /**
     * Create the item view holder.
     *
     * @param parent The ViewGroup into which the new View will be added after it is bound to an adapter position.
     * @param viewType The view type of the new View.
     *
     * @return A new item ViewHolder that holds a View of the given view type.
     */
    private fun onCreateItemViewHolder(itemView: View) = viewHolderClass.constructors.first().call(itemView, this, recyclerView)

    /**
     * {@inheritDoc}
     */
    override fun getItemViewType(position: Int) = when {
        headerClass.isInstance(differ.currentList[position]) -> HEADER_TYPE
        itemClass.isInstance(differ.currentList[position]) -> ITEM_TYPE
        else -> GENERIC_TYPE_EMPTY
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = when (viewType) {
        HEADER_TYPE -> onCreateSubHeaderViewHolder(LayoutInflater.from(parent.context).inflate(sectionLayout, parent, false))
        ITEM_TYPE -> onCreateItemViewHolder(LayoutInflater.from(parent.context).inflate(itemLayout, parent, false))
        GENERIC_TYPE -> StateCardViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_view_state, parent, false))
        else -> StateCardFullViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_view_state_full, parent, false))
    }

    internal fun relayClickListener(index: Int, obj: D, type: Enum<*>) {
        clickListener(this, index, obj, type)
    }

    @Suppress("UNCHECKED_CAST")
    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder.itemViewType) {
            HEADER_TYPE -> {
                val item = differ.currentList[position] as Header
                (holder as SH).bind(position, item)
            }
            ITEM_TYPE -> {
                val item = differ.currentList[position] as Item
                (holder as VH).bind(position, item, ::relayClickListener)
            }
            GENERIC_TYPE, GENERIC_TYPE_EMPTY -> {
                val item = differ.currentList[position]
                when (holder.itemViewType) {
                    GENERIC_TYPE -> (holder as StateCardViewHolder).bind(holder, item as StateCard?, errorClickListener, errorViews)
                    GENERIC_TYPE_EMPTY -> (holder as StateCardFullViewHolder).bind(holder, item as StateCard?, errorClickListener, errorViews)
                }
            }
        }
    }

    override fun getItemCount() = differ.currentList.size

}