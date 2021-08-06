package ${configs.packageName}.utils.helper.extensions.time

import org.threeten.bp.ZoneId
import org.threeten.bp.ZoneOffset
import org.threeten.bp.ZonedDateTime

/**
 * returns the same date but in 0 hour 00:00:00
 */
fun ZonedDateTime.withZeroTime() : ZonedDateTime {
    return this.withHour(0).withMinute(0).withSecond(0).withNano(0)
}

/**
 * converts a date without any timezone (is in UTC) to a zoned date
 * example:
 * (UTC -> zone with +01:00)
 * 2020-05-01 02:12 -> 2020-05-01 03:12+0100
 *
 */
fun ZonedDateTime.atLocalZone() : ZonedDateTime {
    return this.withZoneSameInstant(ZoneId.systemDefault())
}

/**
 * converts a date with any timezone to UTC
 * example:
 * (zone with +01:00 -> UTC)
 * 2020-05-01 02:12+0100 -> 2020-05-01 01:12+0000
 *
 */
fun ZonedDateTime.atUTC() : ZonedDateTime {
    return this.withZoneSameInstant(ZoneOffset.UTC)
}