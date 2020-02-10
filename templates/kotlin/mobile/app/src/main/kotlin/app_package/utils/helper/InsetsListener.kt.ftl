package ${configs.packageName}.utils.helper

import android.view.View
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class InsetsListener {

    private var runOnce = false
    private var statusHeight = 0

    fun listenStatusHeightChange(view : View, block : (v: View, insets : WindowInsetsCompat) -> Unit) {
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            if(insets.systemWindowInsetTop != statusHeight && !runOnce) {
                statusHeight = insets.systemWindowInsetTop
                runOnce = true
                block.invoke(v, insets)
            }

            insets.consumeSystemWindowInsets()
        }
    }

    fun listen(view : View, block : (v: View, insets : WindowInsetsCompat) -> Unit) {
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            block.invoke(v, insets)

            insets.consumeSystemWindowInsets()
        }
    }


}