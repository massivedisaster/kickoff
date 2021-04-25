package ${configs.packageName}.ui.base.adapter.horizontaladapter

import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.databinding.ItemCategoryBinding
import ${configs.packageName}.network.models.response.CategoryModel
import ${configs.packageName}.ui.base.adapter.ClickType
import ${configs.packageName}.ui.widgets.itemdecorators.HorizontalSpaceItemDecoration
import ${configs.packageName}.utils.helper.extensions.dpInPx

class HorizontalsViewHolder(itemView: View, private val recyclerViewPool: RecyclerView.RecycledViewPool) : RecyclerView.ViewHolder(itemView) {

    private val expLayoutManager = object : LinearLayoutManager(itemView.context, RecyclerView.HORIZONTAL, false) {
        override fun canScrollVertically() = false
    }

    fun bind(item: CategoryModel?, clickListener: (obj: CategoryModel, type: Enum<*>) -> Unit, itemsAdapter: RecyclerView.Adapter<RecyclerView.ViewHolder>?) {

        val dataBinding: ItemCategoryBinding? = DataBindingUtil.bind(itemView)

        dataBinding?.let { holder ->
            holder.recyclerList.apply {
                setRecycledViewPool(recyclerViewPool)
                if (itemDecorationCount <= 0) {
                    addItemDecoration(HorizontalSpaceItemDecoration(10F.dpInPx(holder.recyclerList.context)))
                }
                layoutManager = expLayoutManager
                clipChildren = false
                isNestedScrollingEnabled = false

                adapter = itemsAdapter
                itemAnimator?.changeDuration = 0
            }

            item?.let {
                holder.itemTextView.text = item.name

                holder.category.setOnClickListener {
                    clickListener.invoke(item, ClickType.SEE_MORE)
                }
            }
        }
    }

}