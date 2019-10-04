package ${configs.packageName}.data.common

import ${configs.packageName}.network.models.ApiErrorResponse

class NetworkState(
    val status: Int,
    val error: ApiErrorResponse<*>? = null
) {
    val isLoading: Boolean
        get() = status == Status.LOADING

    val isSuccess: Boolean
        get() = status == Status.SUCCESS

    val isFailed: Boolean
        get() = status == Status.FAILED

    val isEmpty: Boolean
        get() = status == Status.EMPTY

    val statusString: String
        get() {
            return when (status) {
                Status.LOADING -> "running"
                Status.SUCCESS -> "success"
                Status.EMPTY -> "empty"
                else -> "failed"
            }
        }

    companion object {
        val SUCCESS = NetworkState(Status.SUCCESS)
        val LOADING = NetworkState(Status.LOADING)
        val EMPTY = NetworkState(Status.EMPTY)
        fun error(error: ApiErrorResponse<*>?) = NetworkState(Status.FAILED, error)
    }
}

object Status {
    const val LOADING = 0
    const val SUCCESS = 1
    const val FAILED = 2
    const val EMPTY = 3
}