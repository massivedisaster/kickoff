package ${configs.packageName}.data.common

import okhttp3.Headers

data class CallResult<T>(val status: NetworkState, val code: Int, val data: T?, val message: String?, val headers: Headers? = null, val connection: NetworkBoundResource<T, *, *>? = null) {

    companion object {
        fun <T> success(code: Int, data: T?, headers: Headers?, val connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.SUCCESS, code, data, null, headers)

        fun <T> error(message: String?, code: Int, data: T?, error: ApiErrorResponse<*>?, val connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.error(error), code, data, message)

        fun <T> error(message: String?, code: Int, data: String?, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.error(null), code, null as T?, data, null, connection)

        fun <T> loading(data: T? = null, code: Int = 0, val connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.LOADING, code, data, null)

        fun <T> empty(status: NetworkState, code: Int, message: String?, data: T? = null, val connection: NetworkBoundResource<T, *, *>? = null) = CallResult(status, code, data, message, null)
    }

}