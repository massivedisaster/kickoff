package ${configs.packageName}.utils.helper.extensions

import android.view.View
import android.view.View.*

fun View.removeView() {
    visibility = GONE
}

fun View.removeView(set: TransitionSet) {
    TransitionManager.beginDelayedTransition(parent as ViewGroup, set)
    visibility = GONE
}

fun View.hideView() {
    visibility = INVISIBLE
}

fun View.showView(set: TransitionSet) {
    TransitionManager.beginDelayedTransition(parent as ViewGroup, set)
    visibility = VISIBLE
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

/**
 * Animates the view to rotate, can be refactored for more abstraction if needed
 *
 * @param rotation Value of rotation to be applied to view
 * @param duration Duration of the rotation animation
 */
fun View.rotateAnimation(rotation: Float, duration: Long) {
    val interpolator = OvershootInterpolator()
    isActivated = if (!isActivated) {
        ViewCompat.animate(this).rotation(rotation).withLayer().setDuration(duration).setInterpolator(interpolator).start()
        !isActivated
    } else {
        ViewCompat.animate(this).rotation(0f).withLayer().setDuration(duration).setInterpolator(interpolator).start()
        !isActivated
    }
}