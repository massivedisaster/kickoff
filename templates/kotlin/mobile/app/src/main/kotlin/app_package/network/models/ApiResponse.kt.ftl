package ${configs.packageName}.network.models

import com.fasterxml.jackson.databind.JsonMappingException
import okhttp3.Headers
import ${configs.packageName}.data.common.ServerError
import ${configs.packageName}.network.models.response.ApiError
import ${configs.packageName}.utils.manager.PreferencesManager
import retrofit2.HttpException
import retrofit2.Response
import java.net.SocketTimeoutException
import java.net.UnknownHostException

@Suppress("unused")
sealed class ApiResponse<T> {

    companion object {
        const val ERROR = "Something went wrong"
        fun <T> create(url: String, throwable: Throwable): ApiErrorResponse<T> {
            throwable.printStackTrace()

            if (throwable is SocketTimeoutException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: ERROR, ServerError.TIMEOUT)
            }

            if (throwable is JsonMappingException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: ERROR, ServerError.EMPTY_BODY)
            }

            if (throwable is UnknownHostException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: ERROR, ServerError.NO_INTERNET)
            }

            if (throwable is HttpException) {
                return ApiErrorResponse(url, throwable.code(), ERROR, ServerError.GENERAL)
            }

            return ApiErrorResponse(url, 520, throwable.message ?: ERROR, ServerError.GENERAL)
        }

        fun <T> create(url: String, response: Response<T>): ApiResponse<T> {
            return if (response.isSuccessful) {
                val body = response.body()
                ApiSuccessResponse(url, response.code(), body, response.headers())
            } else {
                val code = response.code()
                val message = response.errorBody()?.string()
                val error = PreferencesManager.getObject<ApiError>(message)
                val errorMessage = if (message.isNullOrEmpty()) {
                    response.message()
                } else {
                    message
                }
                ApiErrorResponse(url, code, errorMessage ?: ERROR, ServerError.API, error)
            }
        }
    }

}

data class ApiSuccessResponse<T>(val url: String, val successCode: Int, val body: T?, val headers: Headers) : ApiResponse<T>()

data class ApiErrorResponse<T>(val url: String, val errorCode: Int, val errorMessage: String, val serverError: ServerError, val error: ApiError? = null) : ApiResponse<T>()