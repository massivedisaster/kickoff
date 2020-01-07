package ${configs.packageName}.utils.helper.extensions

import android.content.Context
import android.util.TypedValue
import java.math.BigDecimal

fun Float.toPx(context: Context) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, this, context.resources.displayMetrics)

fun Int.toPx(context: Context) = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, this.toFloat(), context.resources.displayMetrics)

fun Float.round(decimalPlace: Int): Float {
    var bd = BigDecimal(this.toDouble())
    bd = bd.setScale(decimalPlace, BigDecimal.ROUND_HALF_UP)
    return bd.toFloat()
}