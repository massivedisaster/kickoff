package ${configs.packageName}.utils.helper.extensions

import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.widget.ImageView
import androidx.databinding.BindingAdapter

fun ImageView.greyScale() {
    val matrix = ColorMatrix()
    matrix.setSaturation(0F)
    this.colorFilter = ColorMatrixColorFilter(matrix)
}

@BindingAdapter("android:imageURL")
fun ImageView.setImageURL(url: String) {
    alpha = 0f
    val valid = url.replace("http", "https")
    //GlideApp.with(context).load(valid).into(this)
}