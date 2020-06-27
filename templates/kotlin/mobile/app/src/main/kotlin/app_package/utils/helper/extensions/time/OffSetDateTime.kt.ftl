package ${configs.packageName}.utils.helper.extensions.time

import org.threeten.bp.OffsetDateTime
import org.threeten.bp.ZonedDateTime

/**
 * returns the same date but in 0 hour 00:00:00
 */
fun OffsetDateTime.withZeroTime() : OffsetDateTime {
    return this.withHour(0).withMinute(0).withSecond(0).withNano(0)
}