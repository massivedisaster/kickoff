package ${configs.packageName}.utils.helper.extensions

import android.os.Handler
import android.os.Looper
import androidx.viewpager2.widget.ViewPager2

*/
fun ViewPager2.autoScroll(interval: Long, handler: Handler) {
    var scrollPosition = 0
    val runnable = object : Runnable {
        override fun run() {
            /**
             * Calculate "scroll position" with
             * adapter pages count and current
             * value of scrollPosition.
             */
            val count = adapter?.itemCount ?: 0
            setCurrentItem(scrollPosition++ % count, true)
            handler.postDelayed(this, interval)
        }
    }

    registerOnPageChangeCallback(object : ViewPager2.OnPageChangeCallback() {
        override fun onPageSelected(position: Int) {
            // Updating "scroll position" when user scrolls manually
            scrollPosition = position + 1
        }
    })

    handler.post(runnable)
}