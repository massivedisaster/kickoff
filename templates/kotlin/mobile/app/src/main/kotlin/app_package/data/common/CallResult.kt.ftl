package ${configs.packageName}.data.common

import okhttp3.Headers

data class CallResult<T>(val status: NetworkState, val code: Int, val data: T?, val message: String?, val headers: Headers? = null, val connection: NetworkBoundResource<T, *, *>? = null) {

    companion object {
        fun <T> success(code: Int, data: T?, headers: Headers?, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.SUCCESS, code, data, null, headers, connection)

        fun <T> error(message: String?, code: Int, data: T?, error: ApiErrorResponse<*>?, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.error(error), code, data, message, null, connection)

        fun <T> error(message: String?, code: Int, data: String?, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.error(null), code, null as T?, data, null, connection)

        fun <T> loading(data: T? = null, code: Int = 0, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.LOADING, code, data, null, null, connection)

        fun <T> empty(code: Int, message: String?, data: T? = null, connection: NetworkBoundResource<T, *, *>? = null) = CallResult(NetworkState.EMPTY, code, data, message, null, connection)
    }

}