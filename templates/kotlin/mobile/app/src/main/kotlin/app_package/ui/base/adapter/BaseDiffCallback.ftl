package ${configs.packageName}.ui.base

import androidx.recyclerview.widget.DiffUtil
import kotlin.reflect.KClass

abstract class BaseDiffCallback<T : Any>(private val itemClass: KClass<T>) : DiffUtil.ItemCallback<Any>() {

    abstract fun itemsTheSame(oldItem: T, newItem: T): Boolean

    abstract fun contentsTheSame(oldItem: T, newItem: T): Boolean

    override fun areItemsTheSame(oldItem: Any, newItem: Any) = when {
        itemClass.isInstance(oldItem) && itemClass.isInstance(newItem) -> itemsTheSame(oldItem as T, newItem as T)
        oldItem is GenericStateCard && newItem is GenericStateCard -> {
            GenericStateCard.areItemsTheSame(oldItem, newItem)
        }
        else -> false
    }

    override fun areContentsTheSame(oldItem: Any, newItem: Any) = when {
        itemClass.isInstance(oldItem) && itemClass.isInstance(newItem) -> contentsTheSame(oldItem as T, newItem as T)
        oldItem is GenericStateCard && newItem is GenericStateCard -> {
            GenericStateCard.areContentsTheSame(oldItem, newItem)
        }
        else -> false
    }

}