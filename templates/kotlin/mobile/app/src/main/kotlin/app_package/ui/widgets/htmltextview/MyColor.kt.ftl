package ${configs.packageName}.ui.widgets.htmltextview

import java.util.*

object MyColor {
    val BLACK = -0x1000000
    private val sColorNameMap: HashMap<String, Int> = HashMap()

    init {
        sColorNameMap["black"] = -0x1000000
        sColorNameMap["darkgray"] = -0xbbbbbc
        sColorNameMap["gray"] = -0x777778
        sColorNameMap["lightgray"] = -0x333334
        sColorNameMap["white"] = -0x1
        sColorNameMap["red"] = -0x10000
        sColorNameMap["green"] = -0xff0100
        sColorNameMap["blue"] = -0xffff01
        sColorNameMap["yellow"] = -0x100
        sColorNameMap["cyan"] = -0xff0001
        sColorNameMap["magenta"] = -0xff01
        sColorNameMap["aqua"] = -0xff0001
        sColorNameMap["fuchsia"] = -0xff01
        sColorNameMap["darkgrey"] = -0xbbbbbc
        sColorNameMap["grey"] = -0x777778
        sColorNameMap["lightgrey"] = -0x333334
        sColorNameMap["lime"] = -0xff0100
        sColorNameMap["maroon"] = -0x800000
        sColorNameMap["navy"] = -0xffff80
        sColorNameMap["olive"] = -0x7f8000
        sColorNameMap["purple"] = -0x7fff80
        sColorNameMap["silver"] = -0x3f3f40
        sColorNameMap["teal"] = -0xff7f80
        sColorNameMap["orange"] = -0x5b00
        sColorNameMap["pink"] = -0x3f35
    }

    fun parseColor(colorString: String): Int {
        if (colorString[0] == '#') {
            // Use a long to avoid rollovers on #ffXXXXXX
            var color = java.lang.Long.parseLong(colorString.substring(1), 16)
            if (colorString.length == 7) {
                // Set the alpha value
                color = color or -0x1000000
            } else if (colorString.length != 9) {
                throw IllegalArgumentException("Unknown color")
            }
            return color.toInt()
        } else {
            val color = sColorNameMap[colorString.toLowerCase(Locale.ROOT)]
            if (color != null) {
                return color
            }
        }
        throw IllegalArgumentException("Unknown color")
    }

    fun getHtmlColor(color: String): Int {
        val i = sColorNameMap[color.toLowerCase(Locale.ROOT)]
        return i ?: try {
            convertValueToInt(color, -1)
        } catch (nfe: NumberFormatException) {
            -1
        }
    }

    fun convertValueToInt(charSeq: CharSequence?, defaultValue: Int): Int {
        if (null == charSeq)
            return defaultValue

        val nm = charSeq.toString()

        // XXX This code is copied from Integer.decode() so we don't
        // have to instantiate an Integer!

        var sign = 1
        var index = 0
        val len = nm.length
        var base = 10

        if ('-' == nm[0]) {
            sign = -1
            index++
        }

        if ('0' == nm[index]) {
            //  Quick check for a zero by itself
            if (index == len - 1)
                return 0

            val c = nm[index + 1]

            if ('x' == c || 'X' == c) {
                index += 2
                base = 16
            } else {
                index++
                base = 8
            }
        } else if ('#' == nm[index]) {
            index++
            base = 16
        }

        return Integer.parseInt(nm.substring(index), base) * sign
    }

}
