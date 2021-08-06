package ${configs.packageName}.utils.helper.extensions

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager.MATCH_DEFAULT_ONLY
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import ${configs.packageName}.R

fun Context.isTablet() = resources.getBoolean(R.bool.isTablet)

enum class Densities {
    XXXHDPI, XXHDPI, XHDPI, HDPI, MDPI
}

fun Context.getDensityName(): Densities {
    val density = resources.displayMetrics.density
    return when {
        density >= 4.0 -> Densities.XXXHDPI
        density >= 3.0 -> Densities.XXHDPI
        density >= 2.0 -> Densities.XHDPI
        density >= 1.5 -> Densities.HDPI
        density >= 1.0 -> Densities.MDPI
        else -> Densities.MDPI
    }
}

fun Context.checkPlayServicesExists(): Boolean {
    val apiAvailability = GoogleApiAvailability.getInstance()
    val resultCode = apiAvailability.isGooglePlayServicesAvailable(this)
    return resultCode == ConnectionResult.SUCCESS
}

fun Context.canResolve(intent: Intent) = packageManager.queryIntentActivities(intent, MATCH_DEFAULT_ONLY).isNotEmpty()