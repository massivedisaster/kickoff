package ${configs.packageName}.ui.base.adapter.horizontaladapter

import androidx.recyclerview.widget.DiffUtil
import ${configs.packageName}.network.models.response.CategoryModel
import ${configs.packageName}.ui.base.adapter.GenericStateCard

class HorizontalsDiffCallback : DiffUtil.ItemCallback<Any>() {

    override fun areItemsTheSame(oldItem: Any, newItem: Any) = when {
        oldItem is Pair<*, *> && newItem is Pair<*, *> -> {
            if (oldItem.first is CategoryModel && oldItem.second is List<*>) {
                (oldItem.first as CategoryModel).id == (newItem.first as CategoryModel).id
            } else {
                false
            }
        }
        oldItem is GenericStateCard && newItem is GenericStateCard -> {
            GenericStateCard.areItemsTheSame(oldItem, newItem)
        }
        else -> false
    }

    override fun areContentsTheSame(oldItem: Any, newItem: Any) = when {
        oldItem is Pair<*, *> && newItem is Pair<*, *> -> {
            if (oldItem.first is CategoryModel && oldItem.second is List<*>) {
                (oldItem.first as CategoryModel).name == (newItem.first as CategoryModel).name
            } else {
                false
            }
        }
        oldItem is GenericStateCard && newItem is GenericStateCard -> {
            GenericStateCard.areContentsTheSame(oldItem, newItem)
        }
        else -> false
    }

}