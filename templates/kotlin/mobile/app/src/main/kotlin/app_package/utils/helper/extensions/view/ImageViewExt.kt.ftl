package ${configs.packageName}.utils.helper.extensions.view

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.graphics.Matrix
import android.graphics.Paint
import android.widget.ImageView
import ${configs.packageName}.utils.glide.GlideApp
import java.io.ByteArrayOutputStream

fun ImageView.greyScale() {
    val matrix = ColorMatrix()
    matrix.setSaturation(0F)
    this.colorFilter = ColorMatrixColorFilter(matrix)
}

fun ImageView.setImageURL(url: String) {
    GlideApp.with(context).load(url).into(this)
}

// extension function to convert bitmap to byte array
fun Bitmap.toByteArray():ByteArray{
    ByteArrayOutputStream().apply {
        compress(Bitmap.CompressFormat.PNG, 100, this)
        return toByteArray()
    }
}

// extension function to convert byte array to bitmap
fun ByteArray.toBitmap() = BitmapFactory.decodeByteArray(this, 0, size)


fun Bitmap.resize(newWidth: Int, newHeight: Int): Bitmap {
    val width: Int = width
    val height: Int = height
    val scaleWidth = newWidth.toFloat() / width
    val scaleHeight = newHeight.toFloat() / height
    // CREATE A MATRIX FOR THE MANIPULATION
    val matrix = Matrix()
    // RESIZE THE BIT MAP
    matrix.postScale(scaleWidth, scaleHeight)

    // "RECREATE" THE NEW BITMAP
    val resizedBitmap = Bitmap.createBitmap(this, 0, 0, width, height, matrix, false)
    recycle()
    return resizedBitmap
}

fun Bitmap.grayScale(): Bitmap {
    val width: Int = width
    val height: Int = height

    val bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val c = Canvas(bmpGrayscale)
    val paint = Paint()
    val cm = ColorMatrix()
    cm.setSaturation(0f)
    val f = ColorMatrixColorFilter(cm)
    paint.colorFilter = f
    c.drawBitmap(this, 0f, 0f, paint)
    return bmpGrayscale
}