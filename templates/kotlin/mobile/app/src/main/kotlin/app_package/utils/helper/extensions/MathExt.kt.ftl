package ${configs.packageName}.utils.helper.extensions

import kotlin.math.*

fun calcDistance(fromLat: Double, fromLon: Double, toLat: Double, toLon: Double): Double {
    val radius = 6378137.0 // approximate Earth radius, *in meters*
    val deltaLat = toLat - fromLat
    val deltaLon = toLon - fromLon
    val angle = 2 * asin(sqrt(sin(deltaLat / 2).pow(2.0) + cos(fromLat) * cos(toLat) * sin(deltaLon / 2).pow(2.0)))
    return radius * angle
}
