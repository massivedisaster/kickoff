package ${configs.packageName}.utils.helper.extensions

import android.util.Base64
import androidx.core.util.PatternsCompat.EMAIL_ADDRESS
import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.Phonenumber
import java.nio.charset.Charset
import java.text.Normalizer

fun String.round(decimalPlace: Int) = String.format("%.${r"${decimalPlace}"}f", this.replace(',', '.').toFloat().round(decimalPlace)).replace('.', ',')

fun String.isEmail() = EMAIL_ADDRESS.matcher(this).matches()

fun String.checkValidUrl() = (startsWith("http") || startsWith("https")) && endsWith("/")

fun String.isPhone(prefix: String) : Boolean { //NOTE: This should probably be a member variable.
    //NOTE: This should probably be a member variable.
    val phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance()

    return try {
        val numberProto: Phonenumber.PhoneNumber = phoneUtil.parse(prefix + this, null)
        phoneUtil.isValidNumber(numberProto)
    } catch (e: NumberParseException) {
        false
    }
}

fun String.capitalizeWords() = split(" ").joinToString(" ") { it.capitalize() }

fun String.shortDayOfMonth(): String {
    val split = split(",").toMutableList()
    split[0] = split[0].substring(0, 3)
    return split.joinToString(",")
}

fun String.toBase64(flag: Int = Base64.DEFAULT) = Base64.encodeToString(this.encodeToByteArray(), flag)

fun String.fromBase64(flag: Int = Base64.DEFAULT) = String(Base64.decode(this, flag), Charset.defaultCharset())

fun String.isValidNIF(ignoreFirst: Boolean = false): Boolean {
    // 1. Remove extra spacing
    val nifValue = this.trim()

    // 2. Verify if value is a Number with length 9
    val isNumber = nifValue.matches("[1-9][0-9]{8}".toRegex())
    if (isNumber) {
        // 3. The first digit must be 1, 2, 3, 5, 6, 8, or 9, unless we opt to 'ignore' this rule
        val allowedFirstDigit: CharArray = charArrayOf('1', '2', '3', '5', '6', '8', '9')
        if (allowedFirstDigit.contains(nifValue.first()) || ignoreFirst) {
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
