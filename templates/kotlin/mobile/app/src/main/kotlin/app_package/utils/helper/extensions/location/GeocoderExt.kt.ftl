package ${configs.packageName}.utils.helper.extensions.location

import android.location.Address
import android.location.Geocoder
import android.os.Build
import androidx.annotation.FloatRange

fun Geocoder.getAddresses(@FloatRange(from = -90.0, to = 90.0) latitude: Double, @FloatRange(from = -180.0, to = 180.0) longitude: Double, maxResults: Int, callback: (List<Address>) -> Unit) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        getFromLocation(latitude, longitude, maxResults) {
            callback(it)
        }
    } else {
        @Suppress("DEPRECATION")
        callback(getFromLocation(latitude, longitude, maxResults) ?: listOf())
    }
}

fun Geocoder.getCurrentAddress(@FloatRange(from = -90.0, to = 90.0) latitude: Double, @FloatRange(from = -180.0, to = 180.0) longitude: Double, callback: (Address?) -> Unit) {
    getAddresses(latitude, longitude, 1) {
        callback(it.getOrNull(0))
    }
}