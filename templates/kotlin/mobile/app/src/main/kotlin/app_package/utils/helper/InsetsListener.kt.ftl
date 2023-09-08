package ${configs.packageName}.utils.helper

import android.view.View
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsCompat.CONSUMED

class InsetsListener {

    private var runOnce = false
    private var statusHeight = 0

    fun listenStatusHeightChange(view : View, block : (v: View, insets : WindowInsetsCompat) -> Unit) {
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            val topInsets = insets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.systemBars()).top
            if(topInsets != statusHeight && !runOnce) {
                statusHeight = topInsets
                runOnce = true
                block.invoke(v, insets)
            }

            CONSUMED
        }
    }

    fun listen(view : View, block : (v: View, insets : WindowInsetsCompat) -> Unit) {
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            block.invoke(v, insets)

            CONSUMED
        }
    }


}