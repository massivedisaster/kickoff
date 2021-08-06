package ${configs.packageName}.utils.helper.extensions

import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.widget.ImageView

fun ImageView.greyScale() {
    val matrix = ColorMatrix()
    matrix.setSaturation(0F)
    this.colorFilter = ColorMatrixColorFilter(matrix)
}