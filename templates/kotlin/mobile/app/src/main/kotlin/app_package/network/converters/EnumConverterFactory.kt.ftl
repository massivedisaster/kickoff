package ${configs.packageName}.network.converters

import ${configs.packageName}.network.models.enums.Content
import retrofit2.Converter
import retrofit2.Retrofit
import java.lang.reflect.Type

class EnumConverterFactory : Converter.Factory() {

    override fun stringConverter(type: Type, annotations: Array<Annotation>, retrofit: Retrofit)
            : Converter<Enum<*>, String>? = if (type is Class<*> && type.isEnum) {
                Converter { enum ->
                    try {
                        if (enum is Content) {
                            enum.value
                        } else {
                            enum.name.toLowerCase()
                        }
                    } catch (exception: Exception) {
                        null
                    } ?: enum.toString().toLowerCase()
                }
            } else {
                null
            }

}