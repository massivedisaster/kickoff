package ${configs.packageName}.network.converters

import retrofit2.Converter
import retrofit2.Retrofit
import java.lang.reflect.Type
import java.util.*

class EnumConverterFactory : Converter.Factory() {

    override fun stringConverter(type: Type, annotations: Array<Annotation>, retrofit: Retrofit)
            : Converter<Enum<*>, String>? = if (type is Class<*> && type.isEnum) {
                Converter { enum ->
                    try {
                        enum.name.lowercase(Locale.getDefault())
                    } catch (exception: Exception) {
                        null
                    } ?: enum.toString().lowercase(Locale.getDefault())
                }
            } else {
                null
            }

}