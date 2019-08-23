package ${configs.packageName}.network.adapter

import ${configs.packageName}.network.models.ApiResponse
import retrofit2.Call
import retrofit2.CallAdapter
import java.lang.reflect.Type

class ApiResponseCallAdapter<T>(private val responseType: Type) : CallAdapter<T, ApiResponse<T>> {

    override fun adapt(call: Call<T>): ApiResponse<T> {
        return try {
            val response =  call.execute ()
            ApiResponse.create(call.request().url.toString(), response)
        } catch (e : Exception) {
            ApiResponse.create(call.request().url.toString(), e)
        }
    }

    override fun responseType() = responseType

}