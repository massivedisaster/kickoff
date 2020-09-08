package ${configs.packageName}.utils.helper.extensions

import android.content.res.ColorStateList
import android.os.Handler
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.textfield.TextInputLayout

/**
 * sets the hint color depending on edittext state (selected/unselected and has/not has text)
 * @param hintColor -> color represeting hint when edittext is empty and unselected (also viewed as hint)
 * @param labelColor -> color represeting hint when edittext is not empty (also viewed as a label)
 */
fun TextInputLayout.setColorStates(hintColor: Int, labelColor: Int) {
    editText?.setOnFocusChangeListener { view, isFocused ->
        if (isFocused) {
            Handler().post {
                this.defaultHintTextColor = ColorStateList.valueOf(ResourcesCompat.getColor(resources, labelColor, null))
            }

        } else {
            Handler().post {
                this.defaultHintTextColor = ColorStateList.valueOf(ResourcesCompat.getColor(resources,
                        if (editText?.text.isNullOrEmpty()) {
                            hintColor
                        } else {
                            labelColor
                        }
                        , null))
            }
        }
    }

}