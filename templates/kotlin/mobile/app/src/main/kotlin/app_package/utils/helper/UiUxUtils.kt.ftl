package ${configs.packageName}.utils.helper


import android.app.Activity
import android.content.Context
import android.graphics.Point
import android.location.LocationManager
import android.util.DisplayMetrics
import android.util.Log
import android.util.Patterns
import android.util.TypedValue
import android.view.View
import android.view.animation.*
import android.view.inputmethod.InputMethodManager
import android.widget.RelativeLayout
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.TextInputLayout
//import ${configs.packageName}.R
import ${configs.packageName}.utils.helper.extensions.isEmail

/**
 * Util class related to Views, Animations etc
 */
object UiUxUtils {

    /**
     * Animates the landing screen by creating a fade in, translation and fade out animations and
     * calling [startLandingAnimations][.startLandingAnimations] method.
     *
     * @param fadeInView    the view do fade in
     * @param fadeOutView   the view to fade out
     * @param slideUpView   the view to slide up
     * @param animationTime the animation duration
     */
    fun animateLanding(fadeInView: View, fadeOutView: View, slideUpView: View, animationTime: Int) {
        // Create Slide up animation
        val slideUpAnimation = translateAnimation(0f, 0f, 0f, -0.25f, animationTime.toLong())
        slideUpView.animation = slideUpAnimation
        // Create Fade in animation
        val fadeInAnimation = fadeAnimation(0f, 1f, animationTime.toLong(), true)
        fadeInView.animation = fadeInAnimation
        // Animation Set with fade in and translate animations
        val animationSet = AnimationSet(true)
        animationSet.addAnimation(slideUpAnimation)
        animationSet.addAnimation(fadeInAnimation)
        // Fade out animation
        startLandingAnimations(animationSet, fadeOutView, animationTime.toLong())
    }

    /**
     * Fade animation with the duration, values from and to, animation duration and offset flag passed by parameter.
     * Can be used to perform either a fade in or fade out animation.
     *
     * @param fromAlpha     the from alpha value
     * @param toAlpha       the to alpha value
     * @param animationTime the fade animation duration
     * @param hasOffSet     flag for the offset
     * @return Animation the fade animation
     */
    fun fadeAnimation(fromAlpha: Float, toAlpha: Float, animationTime: Long, hasOffSet: Boolean): Animation {
        val fadeInAnimation = AlphaAnimation(fromAlpha, toAlpha)
        fadeInAnimation.interpolator = AccelerateInterpolator()
        fadeInAnimation.duration = animationTime
        if (hasOffSet) {
            fadeInAnimation.startOffset = animationTime
        }
        return fadeInAnimation
    }

    /**
     * Translate animation with the X and Y from and to values and the animation's duration passed by parameter.
     * Performs a translation animation.
     *
     * @param translateXFrom the from X value
     * @param translateXTo   the to X value
     * @param translateYFrom the from Y value
     * @param translateYTo   the to Y animation
     * @param animationTime  the translation's duration
     * @return Animation the translate animation
     */
    fun translateAnimation(translateXFrom: Float, translateXTo: Float, translateYFrom: Float, translateYTo: Float, animationTime: Long): Animation {
        val translateY = TranslateAnimation(
            TranslateAnimation.RELATIVE_TO_PARENT, translateXFrom,
            TranslateAnimation.RELATIVE_TO_PARENT, translateXTo,
            TranslateAnimation.RELATIVE_TO_PARENT, translateYFrom,
            TranslateAnimation.RELATIVE_TO_PARENT, translateYTo)

        translateY.interpolator = AccelerateInterpolator()
        translateY.fillAfter = true
        translateY.duration = animationTime
        return translateY
    }

    /**
     * Starts all of the landing's animations by performing simultaneously a fade out animation,
     * on the view given by parameter along with it's duration, and a fade in and translate animation contained
     * in an Animation Set also passed by parameter.
     *
     * @param animationSet  the animation set
     * @param fadeOutView   the view to fade out
     * @param animationTime the duration of the animation
     */
    private fun startLandingAnimations(animationSet: AnimationSet, fadeOutView: View, animationTime: Long) {
        val fadeOut = fadeAnimation(1f, 0f, animationTime, false)
        fadeOut.setAnimationListener(object : Animation.AnimationListener {
            override fun onAnimationStart(animation: Animation) {
                animationSet.start()
            }

            override fun onAnimationEnd(animation: Animation) {
                fadeOutView.visibility = View.GONE
            }

            override fun onAnimationRepeat(animation: Animation) { }
        })
        fadeOutView.startAnimation(fadeOut)
    }

    /**
     * Show a snack bar with a message, and a button with an action.
     *
     * @param inject          [View] The view where snackbar will be injected.
     * @param messageResId    int Resource with the message string.
     * @param actionTextResId int Resource with the message string.
     * @param clickListener   [View.OnClickListener] The action of the button.
     */
    fun showSnackBarMessage(inject: View, messageResId: Int, actionTextResId: Int, clickListener: View.OnClickListener) {
        val snackBar = Snackbar.make(inject, messageResId, Snackbar.LENGTH_INDEFINITE)
        val snackBarView = snackBar.view
        snackBar.setAction(actionTextResId, clickListener)
            .setActionTextColor(ContextCompat.getColor(inject.context, android.R.color.white))
            .show()
    }

    /**
     * Show a snack bar with a message, and a button with an action.
     *
     * @param inject          [View] The view where snackbar will be injected.
     * @param message    int Resource with the message string.
     * @param actionTextResId int Resource with the message string.
     * @param clickListener   [View.OnClickListener] The action of the button.
     */
    fun showSnackBarMessage(inject: View, message: String, actionTextResId: Int, clickListener: View.OnClickListener) {
        val snackBar = Snackbar.make(inject, message, Snackbar.LENGTH_INDEFINITE)
        val snackBarView = snackBar.view
        snackBar.setAction(actionTextResId, clickListener)
            .setActionTextColor(ContextCompat.getColor(inject.context, android.R.color.white))
            .show()
    }

    /**
     * Create a confirm to exit dialog
     *
     * @param activity Calling activity/context, activity so it can finish (this is an anti-pattern,
     * usually a helper class should not have the access to do this).
     */
    /*fun confirmExitDialog(activity: Activity) {
        val builder = AlertDialog.Builder(activity)
        builder.setCancelable(false)
        builder.setMessage(activity.resources.getString(R.string.exit_message))
        builder.setPositiveButton(activity.resources.getString(R.string.exit_confirm)) { _, _ -> activity.finishAffinity() }
        builder.setNegativeButton(activity.resources.getString(R.string.exit_cancel)) { dialog, _ -> dialog.dismiss() }
        val alert = builder.create()
        alert.show()
    }*/

}
