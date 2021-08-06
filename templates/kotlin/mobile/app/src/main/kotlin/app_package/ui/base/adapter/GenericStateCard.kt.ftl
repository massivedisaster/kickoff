package ${configs.packageName}.ui.base.adapter

import ${configs.packageName}.data.common.NetworkState

data class GenericStateCard(
        var showingLoading: Boolean = true,
        var showingEmptyContent: Boolean = false,
        var showingError: Boolean = false,
        var contextualObj: Any? = null,
        var state : NetworkState? = null
) {
    companion object {
        fun getLoadingEmptyList(state: NetworkState? = null, contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = true, showingEmptyContent = false, showingError = false, contextualObj = contextualObj, state = state))

        fun getEmptyContentEmptyList(state: NetworkState? = null, contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = true, showingError = false, contextualObj = contextualObj, state = state))

        fun getErrorEmptyList(state: NetworkState? = null, contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = false, showingError = true, contextualObj = contextualObj, state = state))

        fun areItemsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem == newItem

        fun areContentsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem.showingLoading == newItem.showingLoading
                && oldItem.showingEmptyContent == newItem.showingEmptyContent && oldItem.showingError == newItem.showingError
                && oldItem.contextualObj == newItem.contextualObj

        fun isListGenericCardLoading(list : MutableList<*>?) = (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingLoading

        fun isListGenericCardEmpty(list : MutableList<*>?) = (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingEmptyContent

        fun isListGenericCardError(list : MutableList<*>?) = (list.isNullOrEmpty() || list[0] is GenericStateCard) && (list?.get(0) as GenericStateCard).showingError

        fun isListGenericCard(list : MutableList<*>?) = (list.isNullOrEmpty() || list[0] is GenericStateCard)

        fun MutableList<*>?.GenericCardLoading() = (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingLoading)

        fun MutableList<*>?.isGenericCardEmpty() = (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingEmptyContent)

        fun MutableList<*>?.isGenericCardError() = (isNullOrEmpty() || this?.get(0) is GenericStateCard) && (!isNullOrEmpty() && (this?.get(0) as GenericStateCard).showingError)

        fun MutableList<*>?.isGenericCard() = isNullOrEmpty() || (!isNullOrEmpty() && this?.get(0) is GenericStateCard)
    }
}