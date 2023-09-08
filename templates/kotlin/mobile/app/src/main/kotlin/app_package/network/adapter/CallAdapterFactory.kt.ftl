package ${configs.packageName}.network.adapter

import androidx.lifecycle.LiveData
import ${configs.packageName}.network.models.ApiResponse
import retrofit2.CallAdapter
import retrofit2.CallAdapter.Factory
import retrofit2.Retrofit
import java.lang.reflect.ParameterizedType
import java.lang.reflect.Type

class CallAdapterFactory : Factory() {

    override fun get(returnType: Type, annotations: Array<out Annotation>?, retrofit: Retrofit?): CallAdapter<*, *>? {
        if (getRawType(returnType) != LiveData::class.java && getRawType(returnType) != ApiResponse::class.java) {
            return null
        }

        if(getRawType(returnType) == LiveData::class.java) {
            val observableType = getParameterUpperBound(0, returnType as ParameterizedType)
            val rawObservableType = getRawType(observableType)

            if (rawObservableType != ApiResponse::class.java) {
                throw IllegalArgumentException("Type must be a resource")
            }

            if (observableType !is ParameterizedType) {
                throw IllegalArgumentException("Resource must be parameterized!")
            }

            val bodyType = getParameterUpperBound(0, observableType)
            return LiveDataCallAdapter<Any>(bodyType)
        } else {
            val bodyType = getParameterUpperBound(0, returnType as ParameterizedType)
            return ApiResponseCallAdapter<Any>(bodyType)
        }
    }

}