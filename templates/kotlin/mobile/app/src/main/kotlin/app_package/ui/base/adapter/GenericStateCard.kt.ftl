package ${configs.packageName}.ui.base.adapter

import ${configs.packageName}.data.common.NetworkState

data class GenericStateCard(
        var showingLoading: Boolean = true,
        var showingEmptyContent: Boolean = false,
        var showingError: Boolean = false,

        var contextualObj : NetworkState? = null
) {
    companion object {
        fun getLoadingEmptyList(contextualObj : NetworkState? = null) = mutableListOf(GenericStateCard(showingLoading = true, showingEmptyContent = false, showingError = false, contextualObj = contextualObj))

        fun getEmptyContentEmptyList(contextualObj : NetworkState? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = true, showingError = false, contextualObj = contextualObj))

        fun getErrorEmptyList(contextualObj : NetworkState? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = false, showingError = true, contextualObj = contextualObj))

        fun areItemsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem == newItem

        fun areContentsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem.showingLoading == newItem.showingLoading
                && oldItem.showingEmptyContent == newItem.showingEmptyContent && oldItem.showingError == newItem.showingError
                && oldItem.contextualObj == newItem.contextualObj


        fun isListGenericCardLoading(list : MutableList<*>?): Boolean {
            return (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingLoading
        }

        fun isListGenericCardEmpty(list : MutableList<*>?): Boolean {
            return (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingEmptyContent
        }

        fun isListGenericCardError(list : MutableList<*>?): Boolean {
            return (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingError
        }

        fun isListGenericCard(list : MutableList<*>?): Boolean {
            return (list.isNullOrEmpty() || list[0] is GenericStateCard)
        }

        fun MutableList<*>?.GenericCardLoading() : Boolean {
            return (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingLoading)
        }

        fun MutableList<*>?.isGenericCardEmpty() : Boolean {
            return (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingEmptyContent)
        }

        fun MutableList<*>?.isGenericCardError() : Boolean {
            return (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingError)
        }

        fun MutableList<*>?.isGenericCard() : Boolean {
            return isNullOrEmpty() || (!isNullOrEmpty() && this?.get(0) is GenericStateCard)
        }
    }
}