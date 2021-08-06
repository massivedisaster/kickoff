package ${configs.packageName}.utils.helper.extensions

import android.content.Context
import android.content.Context.INPUT_METHOD_SERVICE
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.core.widget.NestedScrollView

/**
 * (close keyboard on scroll)
 * pass in the views you want to lose focus and close keyboard on scroll of main container (nestedscroll)
 */
fun NestedScrollView.closeKeyboardOnScroll(ctx : Context, vararg views: View) {
    setOnScrollChangeListener(NestedScrollView.OnScrollChangeListener { _, _, _, _, _ ->
        for(view in views) {
            if(view.hasFocus()) {
                view.clearFocus()
                val imm = ctx.getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                imm.hideSoftInputFromWindow(view.windowToken, 0)
                break
            }
        }
    })
}