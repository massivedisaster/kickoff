package ${configs.packageName}.utils.helper.extensions.android

import android.content.Context
import androidx.core.content.ContextCompat

fun Int.getColor(ctx : Context) : Int {
    return ContextCompat.getColor(ctx, this)
}