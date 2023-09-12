package ${configs.packageName}.ui.base.adapter.state

import ${configs.packageName}.data.common.NetworkState

data class StateCard(
    var showingLoading: Boolean = false,
    var showingEmpty: Boolean = false,
    var showingError: Boolean = false,
    var subModel: Any? = null,
    var state : NetworkState? = null
) {
    companion object {
        fun getLoadingState(subModel: Any? = null) = mutableListOf(StateCard(showingLoading = true, subModel = subModel))

        fun getEmptyState(subModel: Any? = null) = mutableListOf(StateCard(showingEmpty = true, subModel = subModel))

        fun getErrorState(state: NetworkState? = null, subModel: Any? = null) = mutableListOf(StateCard(showingError = true, subModel = subModel, state = state))

        fun areItemsTheSame(oldItem: StateCard, newItem: StateCard) = oldItem == newItem

        fun areContentsTheSame(oldItem: StateCard, newItem: StateCard) = oldItem.showingLoading == newItem.showingLoading
                && oldItem.showingEmpty == newItem.showingEmpty && oldItem.showingError == newItem.showingError
                && oldItem.subModel == newItem.subModel

    }
}