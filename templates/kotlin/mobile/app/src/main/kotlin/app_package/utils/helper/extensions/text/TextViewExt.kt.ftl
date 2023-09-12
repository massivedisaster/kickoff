package ${configs.packageName}.utils.helper.extensions.text

import android.graphics.Paint
import android.text.Selection
import android.text.Spannable
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.AbsoluteSizeSpan
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.view.View
import android.widget.TextView
import androidx.annotation.ColorRes
import androidx.annotation.FontRes
import ${configs.packageName}.ui.widgets.FontSpan
import ${configs.packageName}.utils.helper.extensions.android.getColor
import ${configs.packageName}.utils.helper.extensions.android.getFont

fun TextView.strikethrough() {
    paintFlags = paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
}

fun TextView.underline() {
    paintFlags = paintFlags or Paint.UNDERLINE_TEXT_FLAG
}

fun TextView.makeLinks(vararg links: Pair<String, View.OnClickListener>) {
    val spannableString = SpannableString(this.text)
    for (link in links) {
        val clickableSpan = object : ClickableSpan() {

            override fun updateDrawState(textPaint: TextPaint) {
                // use this to change the link color
                textPaint.color = this@makeLinks.linkTextColors.defaultColor
                // toggle below value to enable/disable
                // the underline shown below the clickable text
                textPaint.isUnderlineText = true
            }

            override fun onClick(view: View) {
                Selection.setSelection((view as TextView).text as Spannable, 0)
                view.invalidate()
                link.second.onClick(view)
            }
        }
        val startIndexOfLink = this.text.toString().indexOf(link.first)
        spannableString.setSpan(clickableSpan, startIndexOfLink, startIndexOfLink + link.first.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
    }
    this.movementMethod = LinkMovementMethod.getInstance() // without LinkMovementMethod, link can not click
    this.setText(spannableString, TextView.BufferType.SPANNABLE)
}

fun TextView.makeBold(@FontRes font: Int, @ColorRes color: Int, vararg links: String, textSize: Int = -1) {
    val spannable = SpannableString(this.text)
    for (link in links) {
        val startIndexOfLink = this.text.indexOf(link)
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
    this.setText(spannable, TextView.BufferType.SPANNABLE)
}
