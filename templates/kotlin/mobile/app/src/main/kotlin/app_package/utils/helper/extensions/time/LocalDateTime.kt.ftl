package ${configs.packageName}.utils.helper.extensions.time

import org.threeten.bp.*

/**
 * returns the same date but in 0 hour 00:00:00
 */
fun LocalDateTime.withZeroTime() : LocalDateTime {
    return this.withHour(0).withMinute(0).withSecond(0).withNano(0)
}

/**
 * converts a date without any timezone (is in UTC) to a zoned date
 * example:
 * (UTC -> zone with +01:00)
 * 2020-05-01 02:12 -> 2020-05-01 03:12+0100
 *
 */
fun LocalDateTime.utcToZoned() : LocalDateTime {
    return this.atOffset(ZoneOffset.UTC).atZoneSameInstant(ZoneId.systemDefault()).toLocalDateTime()
}


/**
 * converts a date with any timezone to UTC
 * example:
 * (zone with +01:00 -> UTC)
 * 2020-05-01 02:12+0100 -> 2020-05-01 01:12+0000
 *
 */
fun LocalDateTime.atUTC() : LocalDateTime {
    return this.atZone(ZoneId.systemDefault()).withZoneSameInstant(ZoneOffset.UTC).toLocalDateTime()
}

