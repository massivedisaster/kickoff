package ${configs.packageName}.utils.helper.extensions

import android.content.Context
import android.text.Editable
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextWatcher
import android.text.style.MetricAffectingSpan
import android.widget.TextView
import androidx.annotation.FontRes
import androidx.core.content.res.ResourcesCompat
import androidx.core.util.PatternsCompat.EMAIL_ADDRESS
import com.google.android.material.textfield.TextInputLayout
import java.util.*

fun String.round(decimalPlace: Int) = String.format("%.${r"${decimalPlace}"}f", this.replace(',', '.').toFloat().round(decimalPlace)).replace('.', ',')

fun String.isEmail() = EMAIL_ADDRESS.matcher(this).matches()

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
