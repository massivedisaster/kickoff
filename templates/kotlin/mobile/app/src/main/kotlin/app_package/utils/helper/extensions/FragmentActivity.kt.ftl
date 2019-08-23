package ${configs.packageName}.utils.helper.extensions

import android.app.Activity
import android.content.Intent
import android.graphics.Point
import androidx.fragment.app.FragmentActivity
import ${configs.packageName}.utils.helper.DebounceTimer

/**
 * starts an activity using a debouncer (fast click avoidance)
 */
fun FragmentActivity.startActivityDebounced(intent : Intent, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivity(intent)
    }
}

/**
 * starts an activity for result using a debouncer (fast click avoidance)
 */
fun FragmentActivity.startActivityForResultDebounced(intent : Intent, requestCode : Int, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivityForResult(intent, requestCode)
    }
}

/**
 * returns screen width
 */
fun FragmentActivity.getDisplayWidth(): Int {
    val size = Point()
    windowManager.defaultDisplay.getSize(size)

    return size.x
}

/**
 * returns screen height
 */
fun FragmentActivity.getDisplayHeight(): Int {
    val size = Point()
    windowManager.defaultDisplay.getSize(size)

    return size.y
}