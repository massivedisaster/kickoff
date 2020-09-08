package ${configs.packageName}.network.converters

import okhttp3.RequestBody
import okhttp3.ResponseBody
import retrofit2.Converter
import retrofit2.Retrofit
import java.lang.reflect.Type
import kotlin.reflect.KClass


class AnnotatedConverter(
        private val requestConverterFactoryMap: Map<KClass<*>, Converter.Factory>,
        private val responseConverterFactoryMap: Map<KClass<*>, Converter.Factory>,
        private val defaultConverterFactory: Converter.Factory
) : Converter.Factory() {
    override fun requestBodyConverter(type: Type, parameterAnnotations: Array<Annotation>, methodAnnotations: Array<Annotation>, retrofit: Retrofit): Converter<*, RequestBody>? {
        for (annotation in methodAnnotations) {
            requestConverterFactoryMap[annotation.annotationClass]?.let {
                return it.requestBodyConverter(type, parameterAnnotations, methodAnnotations, retrofit)
            }
        }

        return defaultConverterFactory.requestBodyConverter(type, parameterAnnotations, methodAnnotations, retrofit)
    }

    override fun responseBodyConverter(type: Type, annotations: Array<Annotation>, retrofit: Retrofit): Converter<ResponseBody, *>? {
        for (annotation in annotations) {
            responseConverterFactoryMap[annotation.annotationClass]?.let {
                return it.responseBodyConverter(type, annotations, retrofit)
            }
        }

        return defaultConverterFactory.responseBodyConverter(type, annotations, retrofit)
    }
}