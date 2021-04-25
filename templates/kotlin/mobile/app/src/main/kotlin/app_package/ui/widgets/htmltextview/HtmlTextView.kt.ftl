/*
 * Copyright (C) 2013-2014 Dominik Schürmann <dominik@dominikschuermann.de>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ${configs.packageName}.ui.widgets.htmltextview

import android.content.Context
import android.text.Html
import android.text.Spannable
import android.util.AttributeSet
import androidx.annotation.RawRes
import androidx.core.text.PrecomputedTextCompat
import androidx.core.widget.TextViewCompat
import java.io.InputStream
import java.util.*

class HtmlTextView : JellyBeanSpanFixTextView {

    var clickableTableSpan: ClickableTableSpan? = null
    var drawTableLinkSpan: DrawTableLinkSpan? = null
    var removeTrailingWhiteSpace = true

    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle)
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs)
    constructor(context: Context) : super(context)

    /**
     * Loads HTML from a raw resource, i.e., a HTML file in res/raw/.
     * This allows translatable resource (e.g., res/raw-de/ for german).
     * The containing HTML is parsed to Android's Spannable format and then displayed.
     *
     * @param resId       for example: R.raw.help
     * @param imageGetter for fetching images. Possible ImageGetter provided by this library:
     * HtmlLocalImageGetter and HtmlRemoteImageGetter
     */
    @JvmOverloads
    fun setHtml(@RawRes resId: Int, imageGetter: Html.ImageGetter? = null) {
        val inputStreamText = context.resources.openRawResource(resId)
        setHtml(convertStreamToString(inputStreamText), imageGetter)
    }

    /**
     * Loads HTML from a raw resource, i.e., a HTML file in res/raw/.
     * This allows translatable resource (e.g., res/raw-de/ for german).
     * The containing HTML is parsed to Android's Spannable format and then displayed.
     *
     * @param resId       for example: R.raw.help
     * @param imageGetter for fetching images. Possible ImageGetter provided by this library:
     * HtmlLocalImageGetter and HtmlRemoteImageGetter
     */
    @JvmOverloads
    fun setFutureHtml(@RawRes resId: Int, imageGetter: Html.ImageGetter? = null) {
        val inputStreamText = context.resources.openRawResource(resId)
        setFutureHtml(convertStreamToString(inputStreamText), imageGetter)
    }

    /**
     * Parses String containing HTML to Android's Spannable format and displays it in this TextView.
     * Using the implementation of Html.ImageGetter provided.
     *
     * @param html        String containing HTML, for example: "**Hello world!**"
     * @param imageGetter for fetching images. Possible ImageGetter provided by this library:
     * HtmlLocalImageGetter and HtmlRemoteImageGetter
     */
    @JvmOverloads
    fun setHtml(html: String?, imageGetter: Html.ImageGetter? = null) {
        val htmlTagHandler = HtmlTagHandler(paint)

        val cleanHtml = htmlTagHandler.overrideTags(html)
        val content = HtmlEnhancementParser.fromHtml(cleanHtml, HtmlEnhancementParser.FROM_HTML_MODE_LEGACY, imageGetter, htmlTagHandler, context, clickableTableSpan, drawTableLinkSpan) as Spannable

        text = if (removeTrailingWhiteSpace) removeHtmlBottomPadding(content) else content

        // make links work
        movementMethod = LocalLinkMovementMethod.getInstance()
    }

    /**
     * Parses String containing HTML to Android's Spannable format and displays it in this TextView.
     * Using the implementation of Html.ImageGetter provided.
     *
     * @param html        String containing HTML, for example: "**Hello world!**"
     * @param imageGetter for fetching images. Possible ImageGetter provided by this library:
     * HtmlLocalImageGetter and HtmlRemoteImageGetter
     */
    @JvmOverloads
    fun setFutureHtml(html: String?, imageGetter: Html.ImageGetter? = null) {
        val htmlTagHandler = HtmlTagHandler(paint)

        val cleanHtml = htmlTagHandler.overrideTags(html)
        val content = HtmlEnhancementParser.fromHtml(cleanHtml, HtmlEnhancementParser.FROM_HTML_MODE_LEGACY, imageGetter, htmlTagHandler, context, clickableTableSpan, drawTableLinkSpan) as Spannable

        setTextFuture(PrecomputedTextCompat.getTextFuture(if (removeTrailingWhiteSpace) removeHtmlBottomPadding(content) else content, TextViewCompat.getTextMetricsParams(this), null))

        // make links work
        movementMethod = LocalLinkMovementMethod.getInstance()
    }

    companion object {
        const val TAG = "HtmlTextView"

        /**
         * http://stackoverflow.com/questions/309424/read-convert-an-inputstream-to-a-string
         */
        private fun convertStreamToString(`is`: InputStream): String {
            val s = Scanner(`is`).useDelimiter("\\A")
            return if (s.hasNext()) s.next() else ""
        }

        /**
         * Html.fromHtml sometimes adds extra space at the bottom.
         * This methods removes this space again.
         * See https://github.com/SufficientlySecure/html-textview/issues/19
         */
        private fun removeHtmlBottomPadding(text: CharSequence): CharSequence {
            var ret: CharSequence = text
            while (ret.isNotEmpty() && ret[ret.length - 1] == '\n') {
                ret = ret.subSequence(0, ret.length - 1)
            }
            return ret
        }
    }
}