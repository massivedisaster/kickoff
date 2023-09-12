package ${configs.packageName}.utils.helper.extensions.text

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.text.Html
import android.text.Spannable
import android.text.SpannableString
import android.text.style.AbsoluteSizeSpan
import android.text.style.ForegroundColorSpan
import android.text.style.UnderlineSpan
import android.util.Base64
import android.widget.TextView
import androidx.annotation.ColorRes
import androidx.annotation.FontRes
import androidx.core.util.PatternsCompat.EMAIL_ADDRESS
import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.Phonenumber
import org.threeten.bp.LocalDate
import org.threeten.bp.ZoneOffset
import org.threeten.bp.format.DateTimeFormatter
import org.threeten.bp.format.DateTimeParseException
import ${configs.packageName}.ui.widgets.FontSpan
import ${configs.packageName}.utils.helper.extensions.android.getColor
import ${configs.packageName}.utils.helper.extensions.android.getFont
import ${configs.packageName}.utils.helper.extensions.html.HtmlTagHandler
import ${configs.packageName}.utils.helper.extensions.html.LocalLinkMovementMethod
import ${configs.packageName}.utils.helper.extensions.px
import ${configs.packageName}.utils.helper.extensions.round
import timber.log.Timber
import java.io.IOException
import java.math.BigInteger
import java.security.MessageDigest
import java.text.Normalizer
import java.util.Locale

fun String.round(decimalPlace: Int) = String.format("%.${r"${decimalPlace}"}f", this.replace(',', '.').toFloat().round(decimalPlace)).replace('.', ',')

fun String.isEmail() = EMAIL_ADDRESS.matcher(this).matches()

fun String.isValidDate(format: DateTimeFormatter): Boolean {
    try {
        LocalDate.parse(this, format)
    } catch (e: DateTimeParseException) {
        return false
    }
    return true
}

fun String.changeDateFormat(src: DateTimeFormatter, dest: DateTimeFormatter): String {
    val date = LocalDate.parse(this, src)
    return date.format(dest)
}

fun String.checkValidUrl() = (startsWith("http") || startsWith("https")) && endsWith("/")

fun String.isPhone(prefix: String = "+351") : Boolean { //NOTE: This should probably be a member variable.
    //NOTE: This should probably be a member variable.
    val phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance()

    return try {
        val numberProto: Phonenumber.PhoneNumber = phoneUtil.parse(prefix + this, null)
        phoneUtil.isValidNumber(numberProto)
    } catch (e: NumberParseException) {
        false
    }
}

fun String.capitalizeWords(separator: String = " ") = split(" ").capitalizeWords(separator)

fun List<String>.capitalizeWords(separator: String = " ") = joinToString(separator) { it.capitalizeWord() }.trim()

fun String.capitalizeWord() = lowercase(Locale.ROOT).replaceFirstChar(Char::titlecase)

fun String.shortDayOfMonth(): String {
    val split = split(",").toMutableList()
    split[0] = split[0].substring(0, 3)
    return split.joinToString(",")
}

fun String.toBase64(flag: Int = Base64.DEFAULT) = Base64.encodeToString(this.toByteArray(), flag)

fun String.fromBase64(flag: Int = Base64.DEFAULT) = Base64.decode(this.toByteArray(), flag)

fun String.toMd5(): String {
    val md = MessageDigest.getInstance("MD5")
    return BigInteger(1, md.digest(toByteArray())).toString(16).padStart(32, '0')
}

fun String.isValidNIF(): Boolean {
    // 1. Remove extra spacing
    val nifValue = this.trim()

    // 2. Verify if value is a Number with length 9
    val isNumber = nifValue.matches("[1-9][0-9]{8}".toRegex())
    if (isNumber) {
        // 3. The first digit must be 1, 2, 3, 5, 6, 8, or 9, unless we opt to 'ignore' this rule
        val allowedFirstDigit: CharArray = charArrayOf('1', '2', '3', '5', '6', '8', '9')
        if (allowedFirstDigit.contains(nifValue.first())) {
            // 4. We calculate the control digit
            var checkDigit = 0

            nifValue.forEachIndexed { index, digit ->
                if (index < 8) {
                    checkDigit += digit.toString().toInt() * (9 - index)
                }
            }

            checkDigit = 11 - (checkDigit % 11)

            // 5. If 10 or greater, then the control digit is 0
            if (checkDigit >= 10) { checkDigit = 0 }

            // 6. Finally, we compare the last digit
            return checkDigit == nifValue[nifValue.length - 1].toString().toInt()
        }
    }

    return false
}

fun String.isPostalCode() = this.matches("[1-9][0-9]{3}-[0-9]{3}".toRegex())

fun String.normalize(): String {
    var stringNormalized: String = Normalizer.normalize(this, Normalizer.Form.NFD)
    stringNormalized = stringNormalized.replace("[^\\p{ASCII}]".toRegex(), "")
    return stringNormalized
}

fun String.removeWhiteSpaces(): String {
    var result = replace("\\s+".toRegex(), " ")
    if (result[0] == ' ') {
        result = result.drop(1)
    }
    if (result[result.length-1] == ' ') {
        result = result.dropLast(1)
    }

    return result
}

/**
 * Formats the TextView text to HTML.
 */
fun TextView.setHtml(string: String?) {
    string?.let {
        val htmlTagHandler = HtmlTagHandler(paint)

        val cleanHtml = htmlTagHandler.overrideTags(it)
        val content = Html.fromHtml(cleanHtml, Html.FROM_HTML_MODE_COMPACT, null, htmlTagHandler)

        text = content.removeHtmlBottomPadding()

        // make links work
        movementMethod = LocalLinkMovementMethod.getInstance()
    }
}

fun CharSequence.removeHtmlBottomPadding(): CharSequence {
    var ret = this
    while (ret.isNotEmpty() && ret[ret.length - 1] == '\n') {
        ret = ret.subSequence(0, ret.length - 1)
    }
    return ret
}

fun String.makeBold(context: Context, @FontRes font: Int, @ColorRes color: Int,
                    vararg links: String, textSize: Int = -1): SpannableString {
    val spannable = SpannableString(this)
    for (link in links) {
        val startIndexOfLink = this.indexOf(link)
        spannable.setSpan(
            FontSpan(font.getFont(context)),
            startIndexOfLink,
            startIndexOfLink + link.length,
            Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        spannable.setSpan(
            ForegroundColorSpan(color.getColor(context)),
            startIndexOfLink,
            startIndexOfLink + link.length,
            Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        if (textSize != -1) {
            spannable.setSpan(
                AbsoluteSizeSpan(textSize, true),
                startIndexOfLink,
                startIndexOfLink + link.length,
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        }
    }
    return spannable
}

fun String.underlineText(): SpannableString {
    val spannable = SpannableString(this)
    spannable.setSpan(UnderlineSpan(), 0, spannable.length, 0)
    return spannable
}

inline fun <reified T : Any> String?.getObject(): T? {
    val mapper = jacksonObjectMapper()
    try {
        if (isNullOrBlank()) return null
        return mapper.readValue(this)
    } catch (e: IOException) {
        e.printStackTrace()
    }
    return null
}

fun Any.getJson(): String? {
    val mapper = jacksonObjectMapper()
    try {
        return mapper.writeValueAsString(this)
    } catch (e: JsonProcessingException) {
        e.printStackTrace()
    }

    return null
}
/**
 * returns the same date but in Epoch Millis value.
 */
fun String.toEpochMillis(format: DateTimeFormatter) = try {
    LocalDate.parse(this, format)
        .atTime(0, 0)
        .toInstant(ZoneOffset.UTC)
        .toEpochMilli()
} catch (e: DateTimeParseException) { null }

fun String.stripTags() = replace("<.*?>".toRegex(),"")

private fun formatCamelCase(input: String, ignore: CharArray, upperCase: Boolean) =
    if (input.isEmpty()) input else StringBuilder(input.length).also {
        var seenSeparator = upperCase
        var seenUpperCase = !upperCase

        input.forEach { c ->
            when (c) {
                in ignore -> {
                    it.append(c)
                    seenSeparator = upperCase
                    seenUpperCase = !upperCase
                }
                in '0'..'9' -> {
                    it.append(c)
                    seenSeparator = false
                    seenUpperCase = false
                }
                in 'a'..'z' -> {
                    it.append(if (seenSeparator) c.uppercaseChar() else c)
                    seenSeparator = false
                    seenUpperCase = false
                }
                in 'A'..'Z' -> {
                    it.append(if (seenUpperCase) c.lowercaseChar() else c)
                    seenSeparator = false
                    seenUpperCase = true
                }
                else -> if (it.isNotEmpty()) {
                    seenSeparator = true
                    seenUpperCase = false
                }
            }
        }
    }.toString()

/**
 * Format this [String] in **lowerCamelCase** (aka. _mixedCase_,
 * _Smalltalk case_, …).
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **lowerCamelCase** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toLowerCamelCase
 */
fun String.toLowerCamelCase(vararg ignore: Char): String =
    formatCamelCase(this, ignore, false)

/**
 * Format this [String] in **UpperCamelCase** (aka. _PascalCase_, _WikiCase_,
 * …).
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **UpperCamelCase** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toUpperCamelCase
 */
fun String.toUpperCamelCase(vararg ignore: Char): String =
    formatCamelCase(this, ignore, true)

private fun formatCase(input: String, separator: Char, ignore: CharArray, upperCase: Boolean) =
    if (input.isEmpty()) input else StringBuilder(input.length).also {
        var seenSeparator = true
        var seenUpperCase = false

        input.forEach { c ->
            when (c) {
                in ignore -> {
                    it.append(c)
                    seenSeparator = true
                    seenUpperCase = false
                }
                in '0'..'9' -> {
                    it.append(c)
                    seenSeparator = false
                    seenUpperCase = false
                }
                in 'a'..'z' -> {
                    it.append(if (upperCase) c.uppercaseChar() else c)
                    seenSeparator = false
                    seenUpperCase = false
                }
                in 'A'..'Z' -> {
                    if (!seenSeparator && !seenUpperCase) it.append(separator)
                    it.append(if (upperCase) c else c.lowercaseChar())
                    seenSeparator = false
                    seenUpperCase = true
                }
                else -> {
                    if (!seenSeparator || !seenUpperCase) it.append(separator)
                    seenSeparator = true
                    seenUpperCase = false
                }
            }
        }
    }.toString()

private fun formatLowerCase(input: String, separator: Char, ignore: CharArray) =
    formatCase(input, separator, ignore, false)

/**
 * Format this [String] in another **lower case** format where words are
 * separated by the given [separator].
 *
 * @param separator to separate words with
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **lower case** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toLowerCaseFormat
 */
fun String.toLowerCaseFormat(separator: Char, vararg ignore: Char): String =
    formatLowerCase(this, separator, ignore)

/**
 * Format this [String] in **lower-dash-case** (aka. _lower hyphen case_,
 * _lower kebab case_, …).
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **lower-dash-case** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toLowerDashCase
 */
fun String.toLowerDashCase(vararg ignore: Char): String =
    formatLowerCase(this, '-', ignore)

/**
 * Format this [String] in **lower_snake_case**.
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **lower_snake_case** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toLowerSnakeCase
 */
fun String.toLowerSnakeCase(vararg ignore: Char): String =
    formatLowerCase(this, '_', ignore)

private fun formatUpperCase(input: String, separator: Char, ignore: CharArray) =
    formatCase(input, separator, ignore, true)

/**
 * Format this [String] in another **UPPER CASE** format where words are
 * separated by the given [separator].
 *
 * @param separator to separate words with
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **UPPER CASE** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toUpperCaseFormat
 */
fun String.toUpperCaseFormat(separator: Char, vararg ignore: Char): String =
    formatUpperCase(this, separator, ignore)

/**
 * Format this [String] in **UPPER-DASH-CASE** (aka. _upper hyphen case_,
 * _upper kebab case_, …).
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **UPPER-DASH-CASE** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toUpperDashCase
 */
fun String.toUpperDashCase(vararg ignore: Char): String =
    formatUpperCase(this, '-', ignore)

/**
 * Format this [String] in **UPPER_SNAKE_CASE** (aka. _screaming snake case_).
 *
 * @param ignore can be used to specify characters that should be included
 *   verbatim in the result, note that they are still considered separators
 * @receiver [String] to format
 * @return **UPPER_SNAKE_CASE** formatted [String]
 * @since 0.3.0
 * @sample com.fleshgrinder.extensions.kotlin.CaseFormatTest.toUpperSnakeCase
 */
fun String.toUpperSnakeCase(vararg ignore: Char): String =
    formatUpperCase(this, '_', ignore)

