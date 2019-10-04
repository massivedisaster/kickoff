package ${configs.packageName}.utils.helper

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.appcompat.app.AlertDialog
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class GPSHelper : LocationListener {

    companion object {
        // The minimum distance to change Updates in meters
        const val MIN_DISTANCE_CHANGE_FOR_UPDATES = 1F  // 10 meters
        // The minimum time between updates in milliseconds
        const val MIN_TIME_BW_UPDATES = 1L // 1 minute
    }

    private var context: Context

    // flag for GPS status
    var isGPSEnabled = false

    // flag for network status
    var isNetworkEnabled = false

    // flag for GPS status
    var canGetLocation = false

    private var permissionHelper: PermissionHelper

    private var location: Location? = null // location
    var latitude: Double = 0.toDouble() // latitude
    get() {
        if (location != null) {
            field = location?.latitude ?: 0.0
        }

        // return latitude
        return field
    }
    var longitude: Double = 0.toDouble() // longitude
    get() {
        if (location != null) {
            field = location?.longitude ?: 0.0
        }

        // return latitude
        return field
    }
    // Declaring a Location Manager
    protected var locationManager: LocationManager? = null

    @Inject
    constructor(context: Context, permissionHelper: PermissionHelper) {
        this.context = context
        this.permissionHelper = permissionHelper
        obtainLocation()
    }

    @SuppressLint("MissingPermission")
    fun obtainLocation(): Location? {
        try {
            locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager?

            // getting GPS status
            isGPSEnabled = locationManager?.isProviderEnabled(LocationManager.GPS_PROVIDER) ?: false

            Log.v("isGPSEnabled", "=$isGPSEnabled")

            // getting network status
            isNetworkEnabled = locationManager?.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ?: false

            Log.v("isNetworkEnabled", "=$isNetworkEnabled")

            val locationPermission = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
            if ((!isGPSEnabled && !isNetworkEnabled) || !permissionHelper.checkPermissions(context, locationPermission)) {
                // no network provider is enabled
                canGetLocation = false
            } else {
                canGetLocation = true
                if (isNetworkEnabled) {
                    location = null
                    locationManager?.requestLocationUpdates(
                            LocationManager.NETWORK_PROVIDER,
                            MIN_TIME_BW_UPDATES,
                            MIN_DISTANCE_CHANGE_FOR_UPDATES, this)
                    Log.d("Network Enabled", "Network Enabled")
                }
                // if GPS Enabled get lat/long using GPS Services
                if (isGPSEnabled) {
                    location = null
                    if (location == null) {
                        locationManager?.requestLocationUpdates(
                                LocationManager.GPS_PROVIDER,
                                MIN_TIME_BW_UPDATES,
                                MIN_DISTANCE_CHANGE_FOR_UPDATES, this)
                        Log.d("GPS Enabled", "GPS Enabled")
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return location
    }

    /**
    * Stop using GPS listener Calling this function will stop using GPS in your
    * app
    */
    fun stopUsingGPS() {
        if (locationManager != null) {
            locationManager?.removeUpdates(this)
        }
    }

    override fun onLocationChanged(location: Location?) {
        this.location = location
        latitude = location?.latitude ?: 0.0
        longitude = location?.longitude ?: 0.0
    }

    override fun onProviderDisabled(provider: String) {
        when (provider) {
            "gps" -> isGPSEnabled = false
            "network" -> isNetworkEnabled = false
        }
        canGetLocation = isGPSEnabled
    }

    override fun onProviderEnabled(provider: String) {
        when (provider) {
            "gps" -> isGPSEnabled = false
            "network" -> isNetworkEnabled = false
        }
        canGetLocation = isGPSEnabled
    }

    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}

}