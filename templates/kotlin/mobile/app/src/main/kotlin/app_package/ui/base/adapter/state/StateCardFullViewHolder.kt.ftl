package ${configs.packageName}.ui.base.adapter.state

import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.databinding.ItemViewStateFullBinding
import ${configs.packageName}.ui.base.adapter.ClickType
import ${configs.packageName}.utils.helper.extensions.android.isVisible
import ${configs.packageName}.utils.helper.extensions.android.onClick
import ${configs.packageName}.utils.helper.extensions.android.removeView
import ${configs.packageName}.utils.helper.extensions.android.showView

class StateCardFullViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {

    val dataBinding: ItemViewStateFullBinding? = DataBindingUtil.bind(itemView)

    fun bind(holder: StateCardFullViewHolder, card: StateCard?, clickListener: ((ClickType, StateCard) -> Unit)?
             , errorViews: (emptyViews: StateCardViews, errorViews: StateCardViews, state : NetworkState?) -> Unit) {

        val binding = holder.dataBinding ?: return
        var genericStateCard = card
        if(genericStateCard == null) {
            genericStateCard = StateCard(binding.loading.isVisible(), binding.emptyContent.isVisible(), binding.viewError.isVisible())
        }

        binding.genericView.onClick {
            if(genericStateCard.showingLoading) {
                clickListener?.invoke(ClickType.LOADING, genericStateCard)
            }
            if(genericStateCard.showingEmpty) {
                clickListener?.invoke(ClickType.EMPTY_CONTENT, genericStateCard)
            }
            if(genericStateCard.showingError) {
                clickListener?.invoke(ClickType.ERROR, genericStateCard)
            }
        }

        errorViews.invoke(
            StateCardViews(
                icon = binding.emptyIcon,
                title = binding.emptyTitle,
                body = binding.emptyText,
                button = binding.emptyBtn
            ),
            StateCardViews(
                icon = binding.errorIcon,
                title = binding.errorTitle,
                body = binding.errorText,
                button = binding.errorBtn
            ),
            genericStateCard.state
        )

        if(genericStateCard.showingLoading) {
            binding.loading.showView()
            binding.emptyContent.removeView()
            binding.viewError.removeView()
        }

        if(genericStateCard.showingEmpty) {
            binding.loading.removeView()
            binding.emptyContent.showView()
            binding.viewError.removeView()
        }

        if(genericStateCard.showingError) {
            binding.loading.removeView()
            binding.emptyContent.removeView()
            binding.viewError.showView()
        }

    }

}