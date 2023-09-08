package ${configs.packageName}.utils.helper.extensions

import android.graphics.Rect
import android.os.Build
import android.view.View
import android.view.View.*
import android.view.ViewGroup
import android.view.WindowInsets
import android.view.animation.OvershootInterpolator
import androidx.annotation.RequiresApi
import androidx.core.view.ViewCompat
import androidx.core.view.doOnLayout
import androidx.transition.TransitionManager
import androidx.transition.TransitionSet
import ${configs.packageName}.utils.helper.DebounceTimer

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


/**
 * returns true if the current view is visible to the user given the scroll position
 * example: we might have a nestedscrollview with a reyclerview and below it some other views and buttons
 * in certain scenarios we might want to know if the bottom button is currently visible to the user
 *
 * Warning:
 * carefull using this function during initialization (false positives) -> during screen initialization lists are empty
 * and is common that all the views fit the screen, only after content is added (usually to lists) these views go offscreen
 *
 * @param a ViewGroup that support scrolling (nestedscrollview, scrollview, etc)
 */
fun View?.isVisibleInScroller(viewGroupScroller: ViewGroup): Boolean {
    if (this == null) return false
    if (!this.isShown) return false

    val scroller = Rect()
    viewGroupScroller.getHitRect(scroller)
    return this.getLocalVisibleRect(scroller)
}

fun View.onClickDebounce(debouncer: DebounceTimer, milWait: Long = DebounceTimer.DEFAULT_DELAY, action: () -> Unit) {
    setOnClickListener { debouncer.debounceRunFirst(milWait) {
        action()
    } }
}

@RequiresApi(Build.VERSION_CODES.R)
fun View.addKeyboardListener(keyboardCallback: (visible: Boolean) -> Unit) {
    doOnLayout {
        //get init state of keyboard
        var keyboardVisible = rootWindowInsets?.isVisible(WindowInsets.Type.ime()) == true

        //callback as soon as the layout is set with whether the keyboard is open or not
        keyboardCallback(keyboardVisible)

        //whenever the layout resizes/changes, callback with the state of the keyboard.
        viewTreeObserver.addOnGlobalLayoutListener {
            val keyboardUpdateCheck = rootWindowInsets?.isVisible(WindowInsets.Type.ime()) == true
            //since the observer is hit quite often, only callback when there is a change.
            if (keyboardUpdateCheck != keyboardVisible) {
                keyboardCallback(keyboardUpdateCheck)
                keyboardVisible = keyboardUpdateCheck
            }
        }
    }
}

/**
* hides keyboard for current focused activity
*/
fun View.hideKeyboard() {
    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.hideSoftInputFromWindow(windowToken, 0)
}

/**
* hides keyboard for current focused activity
*/
fun View.openKeyboard() {
    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.showSoftInput(this, 0)
}