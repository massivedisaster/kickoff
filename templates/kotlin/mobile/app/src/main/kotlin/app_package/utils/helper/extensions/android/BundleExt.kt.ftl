package ${configs.packageName}.utils.helper.extensions.android

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Parcelable

inline fun <reified T : Enum<T>> Bundle.getEnum(key: String, default: T): T {
    val ordinal = getInt(key, -1)
    return if (ordinal >= 0) enumValues<T>()[ordinal] else default
}

fun <T : Enum<T>> Bundle.putEnum(key: String, value: T?) {
    putInt(key, value?.ordinal ?: -1)
}

fun <T : Enum<T>> Intent.putEnum(key: String, value: T?) {
    putExtra(key, value?.ordinal ?: -1)
}

@SuppressLint("QueryPermissionsNeeded")
@Suppress("DEPRECATION")
fun <T : Parcelable> Bundle.getParcelableCompat(key: String?, clazz: Class<T>) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
    getParcelable(key, clazz)
else
    getParcelable<T>(key)

@SuppressLint("QueryPermissionsNeeded")
@Suppress("DEPRECATION")
fun <T : Parcelable> Bundle.getParcelableArrayListCompat(key: String?, clazz: Class<T>) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
    getParcelableArrayList(key, clazz)
else
    getParcelableArrayList<T>(key)