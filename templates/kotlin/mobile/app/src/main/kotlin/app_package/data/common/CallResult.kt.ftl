package ${configs.packageName}.data.common

import okhttp3.Headers
import ${configs.packageName}.network.models.ApiErrorResponse

data class CallResult<T>(val status: NetworkState, val code: Int, val data: T?, val message: String?, val headers: Headers? = null) {

    companion object {
        fun <T> success(code: Int, data: T?, headers: Headers?) = CallResult(NetworkState.SUCCESS, code, data, null, headers)

        fun <T> error(message: String?, code: Int, data: T?, error: ApiErrorResponse<*>?) = CallResult(NetworkState.error(error), code, data, message, null)

        fun <T> loading(data: T? = null, code: Int = 0) = CallResult(NetworkState.LOADING, code, data, null, null)

        fun <T> empty(code: Int, message: String?, data: T? = null) = CallResult(NetworkState.EMPTY, code, data, message, null)
    }

}