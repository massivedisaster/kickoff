package ${configs.packageName}.data.common

import ${configs.packageName}.network.models.ApiErrorResponse

class NetworkState(val status: Status, val error: ApiErrorResponse<*>? = null) {

    enum class Status {
        LOADING, SUCCESS, FAILED, EMPTY, NO_MORE
    }

    val isLoading = status == Status.LOADING
    val isSuccess = status == Status.SUCCESS
    val isFailed = status == Status.FAILED
    val isEmpty = status == Status.EMPTY
    val isEnd = status == Status.NO_MORE

    val statusString = when (status) {
        Status.LOADING -> "running"
        Status.SUCCESS -> "success"
        Status.EMPTY -> "empty"
        Status.NO_MORE -> "no more"
        else -> "failed"
    }

    companion object {
        val SUCCESS = NetworkState(Status.SUCCESS)
        val LOADING = NetworkState(Status.LOADING)
        val EMPTY = NetworkState(Status.EMPTY)
        val NO_MORE = NetworkState(Status.NO_MORE)
        fun error(error: ApiErrorResponse<*>?) = NetworkState(Status.FAILED, error)
    }

}