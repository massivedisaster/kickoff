package ${configs.packageName}.utils.helper.extensions.text

import android.content.res.ColorStateList
import android.os.Handler
import android.os.Looper
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import ${configs.packageName}.utils.helper.extensions.android.hideKeyboard
import ${configs.packageName}.utils.helper.extensions.android.openKeyboard

/**
 * sets the hint color depending on edittext state (selected/unselected and has/not has text)
 * @param hintColor -> color represeting hint when edittext is empty and unselected (also viewed as hint)
 * @param labelColor -> color represeting hint when edittext is not empty (also viewed as a label)
 */
fun TextInputLayout.setColorStates(hintColor: Int, labelColor: Int) {
    editText?.setOnFocusChangeListener { _, isFocused ->
        if (isFocused) {
            Handler(Looper.getMainLooper()).post {
                this.defaultHintTextColor = ColorStateList.valueOf(ResourcesCompat.getColor(resources, labelColor, null))
            }

        } else {
            Handler(Looper.getMainLooper()).post {
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

/**
 * Checks if an EditText field is empty, if so shows the corresponding error message
 *
 * @param errorMessage the error message
 * @return true if it is an email, false otherwise
 */
fun TextInputLayout.isFieldValidEmail(errorMessage: String): Boolean {
    if (!editText!!.text.toString().isEmail()) {
        error = errorMessage
        return false
    }
    return true
}

/**
 * Checks if an EditText field is empty, if so shows the corresponding error message
 *
 * @param errorMessage the error message
 * @return true if it is empty, false otherwise
 */
fun TextInputLayout.isFieldEmpty(errorMessage: String): Boolean {
    if (editText!!.text.isEmpty()) {
        error = errorMessage
        return true
    }
    return false
}

/**
 * Checks if the password and the confirm password fields match
 *
 * @param password        the password
 * @return boolean, true if they match, false otherwise
 */
fun TextInputLayout.isPasswordMatching(password: TextInputLayout, errorMessage: String): Boolean {
    if (password.editText!!.text.toString() != editText!!.text.toString()) {
        error = errorMessage
        return false
    }

    return true
}

fun TextInputEditText.setupFocusKeyboard() {
    setOnFocusChangeListener { _, hasFocus ->
        if (!hasFocus && findFocus() !is TextInputEditText) hideKeyboard() else openKeyboard()
    }
}