package ${configs.packageName}.utils.helper.extensions.time

import org.threeten.bp.Instant
import org.threeten.bp.LocalDate
import org.threeten.bp.LocalDateTime
import org.threeten.bp.LocalTime
import org.threeten.bp.ZoneId
import org.threeten.bp.ZoneOffset
import org.threeten.bp.ZonedDateTime

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

/**
 * returns the same date but in Epoch Millis value.
 */
fun LocalDate.toEpochMillis() = atTime(LocalTime.MIDNIGHT).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()

fun Long.toLocalDate() = Instant.ofEpochMilli(this).atZone(ZoneId.systemDefault()).toLocalDate()

fun Long.toLocalDateTime() = Instant.ofEpochMilli(this).atZone(ZoneId.systemDefault()).toLocalDateTime()

fun Long.toHours() = (this / (1000 * 60 * 60)).toInt()

fun Long.toMinutes() = ((this / (1000 * 60)) % 60).toInt()

fun Long.toSeconds() = ((this / 1000) % 60).toInt()
