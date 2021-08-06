package ${configs.packageName}.ui.base.adapter

import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView

abstract class BaseViewHolder<T, VB : ViewDataBinding>(itemView: View, private val adapter: RecyclerView.Adapter<*>? = null, private val recyclerView: RecyclerView? = null) : RecyclerView.ViewHolder(itemView) {

    internal val dataBinding: VB? by lazy {
        DataBindingUtil.bind<VB>(itemView)
    }

    abstract fun bind(index: Int, item: T, clickListener: (Int, T, Enum<*>) -> Unit = { _, _, _ -> }, viewPool: RecyclerView.RecycledViewPool? = null)

}