package ${configs.packageName}.utils.helper.extensions.android

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.ColorUtils
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import kotlin.math.roundToInt

fun Int.getColor(ctx: Context) = ContextCompat.getColor(ctx, this)

fun Int.getColorAlpha(alpha: Double): Int {
    val defaultAlpha = 255 // (0 - Invisible / 255 - Max visibility)
    val colorAlpha = alpha.times(defaultAlpha).roundToInt()
    return ColorUtils.setAlphaComponent(this, colorAlpha)
}

fun Int.getDrawable(ctx: Context) = ContextCompat.getDrawable(ctx, this)

fun Int.getFont(ctx: Context) = ResourcesCompat.getFont(ctx, this)

fun Int.getDimension(ctx: Context) = ctx.resources.getDimension(this)

fun Int.bitmapDescriptorFromVector(ctx: Context) = getDrawable(ctx)?.run {
    setBounds(0, 0, intrinsicWidth, intrinsicHeight)
    val bitmap = Bitmap.createBitmap(intrinsicWidth, intrinsicHeight, Bitmap.Config.ARGB_8888)
    draw(Canvas(bitmap))
    BitmapDescriptorFactory.fromBitmap(bitmap)
}