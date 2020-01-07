package ${configs.packageName}.utils.helper.extensions

import android.content.Intent
import androidx.fragment.app.Fragment
import ${configs.packageName}.utils.helper.DebounceTimer

/**
 * starts an activity using a debouncer (fast click avoidance)
 */
fun Fragment.startActivityDebounced(intent : Intent, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivity(intent)
    }
}

/**
 * returns actionBar default size (similar to ?attr/actionBarSize)
 */
fun Fragment.actionBarSize(): Float {
    val styledAttributes = activity?.theme?.obtainStyledAttributes(IntArray(1) { android.R.attr.actionBarSize })
    val actionBarSize = styledAttributes?.getDimension(0, 0F)
    styledAttributes?.recycle()
    return actionBarSize ?: 0F
}