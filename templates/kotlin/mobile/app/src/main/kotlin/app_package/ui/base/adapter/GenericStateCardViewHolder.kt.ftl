package ${configs.packageName}.ui.base.adapter

import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.R
import ${configs.packageName}.databinding.ItemGenericViewStateBinding
import ${configs.packageName}.utils.helper.extensions.isVisible
import ${configs.packageName}.utils.helper.extensions.removeView
import ${configs.packageName}.utils.helper.extensions.showView

class GenericStateCardViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {

    val dataBinding: ItemGenericViewStateBinding? = DataBindingUtil.bind(itemView)

    fun bind(holder: GenericStateCardViewHolder, card: GenericStateCard?, clickListener: ((ClickType, GenericStateCard) -> Unit)?, noContentType: Int = -1) {

        val binding = holder.dataBinding ?: return
        var genericStateCard = card

        if(genericStateCard == null) {
            genericStateCard = GenericStateCard(binding.loading.isVisible()
                    , binding.emptyContent.isVisible()
                    , binding.viewError.isVisible())
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

        if(noContentType != -1) {
            binding.emptyContent.text = itemView.context.getString(R.string.generic_no_content_text, itemView.context.getString(noContentType))
        }

        binding.viewErrorText.text = itemView.context.getString(R.string.generic_error_retry_text)

        if(genericStateCard.showingLoading) {
            binding.loading.showView()
            binding.emptyContent.removeView()
            binding.viewError.removeView()
        }

        if(genericStateCard.showingEmptyContent && noContentType != -1) {
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