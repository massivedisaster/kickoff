package ${configs.packageName}.utils.helper.extensions.android

import android.content.Context
import android.graphics.drawable.Drawable
import androidx.annotation.ColorRes
import androidx.core.content.ContextCompat

fun Drawable.applyColorFilter(@ColorRes colorId: Int, context: Context) {
    this.mutate()
    setTint(ContextCompat.getColor(context, colorId))
}
