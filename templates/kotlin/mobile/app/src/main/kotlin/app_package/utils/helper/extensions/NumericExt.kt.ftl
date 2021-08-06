package ${configs.packageName}.utils.helper.extensions

import android.content.Context
import android.util.DisplayMetrics
import android.util.TypedValue
import java.math.BigDecimal

fun Float.dpInPx(context: Context) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, this, context.resources.displayMetrics)

fun Int.dpInPx(context: Context) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, this.toFloat(), context.resources.displayMetrics)

fun Int.pxInDp(context: Context): Int {
    val resources = context.resources
    val metrics = resources.displayMetrics
    return (this / (metrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
}

fun Float.pxInDp(context: Context): Int {
    val resources = context.resources
    val metrics = resources.displayMetrics
    return (this / (metrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
}

fun Float.round(decimalPlace: Int): Float {
    var bd = BigDecimal(this.toDouble())
    bd = bd.setScale(decimalPlace, BigDecimal.ROUND_HALF_UP)
    return bd.toFloat()
}

fun Long.toHours() = (this / (1000 * 60 * 60)).toInt()

fun Long.toMinutes() = ((this / (1000 * 60)) % 60).toInt()

fun Long.toSeconds() = ((this / 1000) % 60).toInt()