package ${configs.packageName}.network.models

import com.fasterxml.jackson.databind.JsonMappingException
import ${configs.packageName}.data.common.ServerError
import ${configs.packageName}.data.common.ServerErrors
import ${configs.packageName}.network.models.response.ApiError
import ${configs.packageName}.utils.manager.PreferencesManager
import okhttp3.Headers
import retrofit2.HttpException
import retrofit2.Response
import java.net.SocketTimeoutException
import java.net.UnknownHostException

@Suppress("unused")
sealed class ApiResponse<T> {

    companion object {
        fun <T> create(url: String, throwable: Throwable): ApiErrorResponse<T> {
            throwable.printStackTrace()

            if (throwable is SocketTimeoutException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: "Something went wrong", ServerErrors.TIMEOUT)
            }

            if (throwable is JsonMappingException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: "Something went wrong", ServerErrors.EMPTY_BODY)
            }

            if (throwable is UnknownHostException && throwable.message != null) {
                return ApiErrorResponse(url, -1, throwable.message ?: "Something went wrong", ServerErrors.NO_INTERNET)
            }

            if (throwable is HttpException) {
                return ApiErrorResponse(url, throwable.code(), "Something went wrong", ServerErrors.GENERAL)
            }

            return ApiErrorResponse(url, 520, throwable.message ?: "Something went wrong", ServerErrors.GENERAL)
        }

        fun <T> create(url: String, response: Response<T>): ApiResponse<T> {
            return if (response.isSuccessful) {
                val body = response.body()
                ApiSuccessResponse(url, body, response.headers())
            } else {
                val code = response.code()
                val message = response.errorBody()?.string()
                val error = PreferencesManager.getObject<ApiError>(message)
                val errorMessage = if (message.isNullOrEmpty()) {
                    response.message()
                } else {
                    message
                }
                ApiErrorResponse(url, code, errorMessage ?: "Something went wrong", ServerErrors.API, error)
            }
        }
    }

}

data class ApiSuccessResponse<T>(val url: String, val body: T?, val headers: Headers) : ApiResponse<T>()

data class ApiErrorResponse<T>(val url: String, val errorCode: Int, val errorMessage: String, @ServerError val serverError: Int, val error: ApiError? = null) : ApiResponse<T>()