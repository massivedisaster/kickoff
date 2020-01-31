package ${configs.packageName}.ui.base.adapter

import android.view.View
import androidx.recyclerview.widget.RecyclerView

abstract class BaseViewHolder<T>(itemView: View) : RecyclerView.ViewHolder(itemView) {

    abstract fun bind(index: Int, item: T, clickListener: (Int, T, Enum<*>) -> Unit = { _, _, _ -> })

}