package ${configs.packageName}.utils.helper.extensions.view

import android.view.Gravity
import android.view.View
import android.widget.TextView
import androidx.annotation.FontRes
import androidx.annotation.StringRes
import androidx.coordinatorlayout.widget.CoordinatorLayout
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.snackbar.Snackbar
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.extensions.px

fun Snackbar.withFont(@FontRes font: Int): Snackbar{
    val typeface = ResourcesCompat.getFont(context, font)
    this.view.findViewById<TextView>(com.google.android.material.R.id.snackbar_text).typeface = typeface
    return this
}

fun Snackbar.withAnchor(id: Int): Snackbar{
    val layoutParams = view.layoutParams as CoordinatorLayout.LayoutParams
    layoutParams.anchorId = id
    layoutParams.anchorGravity = Gravity.TOP
    layoutParams.gravity = Gravity.TOP
    view.layoutParams = layoutParams
    view.translationY = (-12).px.toFloat()
    return this
}

fun Snackbar.onClickDebounce(debouncer: DebounceTimer, @StringRes resId: Int, action: () -> Unit) {
    setAction(resId) { debouncer.debounceRunFirst {
        action()
    } }
}

fun View.showSnackBar(message: String) {
    val snackbar = Snackbar.make(this, message, Snackbar.LENGTH_SHORT)
    val textView = snackbar.view.findViewById<View>(com.google.android.material.R.id.snackbar_text) as TextView
    textView.maxLines = 2
    snackbar.show()
}

fun View.showSnackBarMessage(@StringRes messageResId: Int, @StringRes actionTextResId: Int, clickListener: View.OnClickListener? = null) {
    val snackBar = Snackbar.make(this, messageResId, Snackbar.LENGTH_INDEFINITE)
    val textView = snackBar.view.findViewById<View>(com.google.android.material.R.id.snackbar_text) as TextView
    textView.maxLines = 2
    snackBar
        .setAction(actionTextResId, clickListener ?: View.OnClickListener { snackBar.dismiss() })
        .setActionTextColor(ContextCompat.getColor(context, android.R.color.white))
        .show()
}