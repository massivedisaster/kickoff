package ${configs.packageName}.ui.base.adapter.horizontaladapter

import ${configs.packageName}.network.models.response.Category
import ${configs.packageName}.ui.base.adapter.BaseDiffCallback
import kotlin.reflect.KClass

class HorizontalsDiffCallback<V : Category>(categoryClass: KClass<V>) : BaseDiffCallback<V>(categoryClass) {

     override fun itemsTheSame(oldItem: V, newItem: V) = oldItem.id == newItem.id

     override fun contentsTheSame(oldItem: V, newItem: V) = oldItem.name == newItem.name

}