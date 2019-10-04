package ${configs.packageName}.utils.helper.extensions

import android.view.View
import android.view.View.*

fun View.removeView() {
    visibility = GONE
}

fun View.hideView() {
    visibility = INVISIBLE
}

fun View.showView() {
    visibility = VISIBLE
}

fun View.showCondition(condition: Boolean, gone: Boolean = true) {
    when {
        condition -> showView()
        gone -> removeView()
        else -> hideView()
    }
}

fun View.isVisible() = visibility == VISIBLE

fun View.enable(alpha: Float = 1f) {
    isEnabled = true
    this.alpha = alpha
}

fun View.disable(alpha: Float = 1f) {
    isEnabled = false
    this.alpha = alpha
}