package ${configs.packageName}.ui.widgets

import android.os.Handler
import android.os.SystemClock
import android.view.View

abstract class OnOneOffClickListener: View.OnClickListener {

    companion object {
        private const val MIN_CLICK_INTERVAL = 600L
        private var isViewClicked = false
    }

    private var lastClickTime = 0L


    abstract fun onSingleClick(v: View?)

    override fun onClick(v: View?) {
        val currentClickTime = SystemClock.uptimeMillis()
        val elapsedTime = currentClickTime - lastClickTime

        lastClickTime = currentClickTime

        if (elapsedTime <= MIN_CLICK_INTERVAL)
            return
        if (!isViewClicked) {
            isViewClicked = true
            startTimer()
        } else {
            return
        }
        onSingleClick(v)
    }

    /**
     * This method delays simultaneous touch events of multiple views.
     */
    private fun startTimer() {
        val handler = Handler()

        handler.postDelayed({ isViewClicked = false }, 600)
    }

}