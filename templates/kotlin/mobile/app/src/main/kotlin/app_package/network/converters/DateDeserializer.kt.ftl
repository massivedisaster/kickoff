package ${configs.packageName}.network.converters

import com.fasterxml.jackson.core.JsonParser
import com.fasterxml.jackson.core.JsonToken
import com.fasterxml.jackson.databind.DeserializationContext
import com.fasterxml.jackson.databind.deser.std.StdDeserializer
import org.threeten.bp.LocalDateTime
import org.threeten.bp.ZoneOffset
import org.threeten.bp.format.DateTimeFormatter

class DateDeserializer : StdDeserializer<LocalDateTime?>(LocalDateTime::class.java) {

    private val formatter: DateTimeFormatter = DateTimeFormatter.ISO_DATE_TIME

    override fun deserialize(jp: JsonParser?, ctxt: DeserializationContext): LocalDateTime? {
        jp?.let {
            val t = jp.currentToken
            if (t === JsonToken.VALUE_STRING) {
                val str = jp.text.trim()
                return LocalDateTime.parse(str, formatter)
            }
            if (t === JsonToken.VALUE_NUMBER_INT) {
                return LocalDateTime.ofEpochSecond(jp.longValue, 0, ZoneOffset.ofTotalSeconds(0))
            }
            ctxt.handleUnexpectedToken(handledType(), ctxt.parser)
        }
        return null
    }

}