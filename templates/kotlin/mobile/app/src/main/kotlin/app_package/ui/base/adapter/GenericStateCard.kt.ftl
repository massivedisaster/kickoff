package ${configs.packageName}.ui.base.adapter

data class GenericStateCard(
        var showingLoading: Boolean = true,
        var showingEmptyContent: Boolean = false,
        var showingError: Boolean = false,

        var contextualObj : Any? = null
) {

    enum class ClickType {
        LOADING,
        EMPTY_CONTENT,
        ERROR
    }

    companion object {
        fun getLoadingEmptyList(contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = true, showingEmptyContent = false, showingError = false, contextualObj = contextualObj))

        fun getEmptyContentEmptyList(contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = true, showingError = false, contextualObj = contextualObj))

        fun getErrorEmptyList(contextualObj : Any? = null) = mutableListOf(GenericStateCard(showingLoading = false, showingEmptyContent = false, showingError = true, contextualObj = contextualObj))

        fun areItemsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem == newItem

        fun areContentsTheSame(oldItem: GenericStateCard, newItem: GenericStateCard) = oldItem.showingLoading == newItem.showingLoading
                && oldItem.showingEmptyContent == newItem.showingEmptyContent && oldItem.showingError == newItem.showingError
                && oldItem.contextualObj == newItem.contextualObj
    }


}