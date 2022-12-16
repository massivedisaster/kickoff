package ${configs.packageName}.ui.base.adapter

import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.databinding.ItemGenericViewStateFullHeightBinding
import ${configs.packageName}.utils.helper.extensions.isVisible
import ${configs.packageName}.utils.helper.extensions.removeView
import ${configs.packageName}.utils.helper.extensions.showView

class GenericStateCardFullHeightViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {

    val dataBinding: ItemGenericViewStateFullHeightBinding? = DataBindingUtil.bind(itemView)

    fun bind(holder: GenericStateCardFullHeightViewHolder, card: GenericStateCard?, clickListener: ((ClickType, GenericStateCard) -> Unit)?
             , errorViews: (emptyViews: GenericStateCardErrorViews, errorViews: GenericStateCardErrorViews, isFullHeight: Boolean, state : NetworkState?) -> Unit) {

        val binding = holder.dataBinding ?: return
        var genericStateCard = card

        if(genericStateCard == null) {
            genericStateCard = GenericStateCard(binding.loading.isVisible(), binding.emptyContent.isVisible(), binding.viewError.isVisible())
        }

        binding.genericView.setOnClickListener {
            if(genericStateCard.showingLoading) {
                clickListener?.invoke(ClickType.LOADING, genericStateCard)
            }
            if(genericStateCard.showingEmptyContent) {
                clickListener?.invoke(ClickType.EMPTY_CONTENT, genericStateCard)
            }
            if(genericStateCard.showingError) {
                clickListener?.invoke(ClickType.ERROR, genericStateCard)
            }
        }

        errorViews(GenericStateCardErrorViews(
            icon = binding.emptyIcon,
            title = binding.emptyTitle,
            body = binding.emptyText,
            button = binding.emptyBtn
        ), GenericStateCardErrorViews(
            icon = binding.errorIcon,
            title = binding.errorTitle,
            body = binding.errorText,
            button = binding.errorBtn
        ),true, genericStateCard.state)

        if(genericStateCard.showingLoading) {
            binding.loading.showView()
            binding.emptyContent.removeView()
            binding.viewError.removeView()
        }

        if(genericStateCard.showingEmptyContent) {
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