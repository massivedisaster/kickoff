package ${configs.packageName}.utils.helper.extensions.time

import org.threeten.bp.*

/**
 * converts a date without any timezone (is in UTC) to a zoned date
 * example:
 * (UTC -> zone with +01:00)
 * 2020-05-01 02:12 -> 2020-05-01 03:12+0100
 *
 */
fun LocalTime.utcToZoned() : ZonedDateTime {
    return this.atDate(LocalDate.now()).atOffset(ZoneOffset.UTC).atZoneSameInstant(ZoneId.systemDefault())
}

/**
 * converts a date with any timezone to UTC
 * example:
 * (zone with +01:00 -> UTC)
 * 2020-05-01 02:12+0100 -> 2020-05-01 01:12+0000
 *
 */
fun LocalTime.atUTC() : ZonedDateTime {
    return this.atDate(LocalDate.now()).atZone(ZoneId.systemDefault()).withZoneSameInstant(ZoneOffset.UTC)
}