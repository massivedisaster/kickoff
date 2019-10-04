package ${configs.packageName}.network.adapter

import androidx.lifecycle.LiveData
import ${configs.packageName}.network.models.ApiResponse
import retrofit2.Call
import retrofit2.CallAdapter
import retrofit2.Callback
import retrofit2.Response
import java.lang.reflect.Type
import java.util.concurrent.atomic.AtomicBoolean

class LiveDataCallAdapter<T>(private val responseType: Type) : CallAdapter<T, LiveData<ApiResponse<T>>> {

    override fun adapt(call: Call<T>): LiveData<ApiResponse<T>> {
        return object : LiveData<ApiResponse<T>>() {
            private var started = AtomicBoolean(false)

            override fun onActive() {
                super.onActive()
                if (started.compareAndSet(false, true)) {
                    call.enqueue(object : Callback<T> {
                        override fun onFailure(call: Call<T>?, throwable: Throwable) {
                            postValue(ApiResponse.create(call?.request()?.url.toString(), throwable))
                        }

                        override fun onResponse(call: Call<T>?, response: Response<T>) {
                            postValue(ApiResponse.create(call?.request()?.url.toString(), response))
                        }
                    })
                }
            }
        }
    }

    override fun responseType() = responseType

}