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
import java.util.*

fun String.round(decimalPlace: Int) = String.format("%.${decimalPlace}f", this.replace(',', '.').toFloat().round(decimalPlace)).replace('.', ',')

fun String.isEmail() = EMAIL_ADDRESS.matcher(this).matches()