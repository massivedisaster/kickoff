package ${configs.packageName}.utils.helper.extensions

import android.view.Gravity
import android.widget.TextView
import androidx.annotation.FontRes
import androidx.annotation.StringRes
import androidx.coordinatorlayout.widget.CoordinatorLayout
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.snackbar.Snackbar
import ${configs.packageName}.R
import ${configs.packageName}.utils.helper.DebounceTimer

fun Snackbar.withFont(@FontRes font: Int): Snackbar{
    val typeface = ResourcesCompat.getFont(context, font)
    this.view.findViewById<TextView>(R.id.snackbar_text).typeface = typeface
    return this
}

fun Snackbar.withAnchor(id: Int): Snackbar{
    val layoutParams = view.layoutParams as CoordinatorLayout.LayoutParams
    layoutParams.anchorId = id
    layoutParams.anchorGravity = Gravity.TOP
    layoutParams.gravity = Gravity.TOP
    view.layoutParams = layoutParams
    view.translationY = (-12).dpInPx(context)
    return this
}

fun Snackbar.onClickDebounce(debouncer: DebounceTimer, @StringRes resId: Int, action: () -> Unit) {
    setAction(resId) { debouncer.debounceRunFirst {
        action()
    } }
}