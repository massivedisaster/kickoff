package ${configs.packageName}.utils.helper.extensions

import android.graphics.Paint
import android.widget.TextView

fun TextView.strikethrough() {
    paintFlags = paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
}