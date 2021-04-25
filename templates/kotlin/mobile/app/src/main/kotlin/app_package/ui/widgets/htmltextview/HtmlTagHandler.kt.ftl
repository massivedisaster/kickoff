/*
 * Copyright (C) 2013-2015 Dominik Schürmann <dominik@dominikschuermann.de>
 * Copyright (C) 2013-2015 Juha Kuitunen
 * Copyright (C) 2013 Mohammed Lakkadshaw
 * Copyright (C) 2007 The Android Open Source Project
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

import android.text.*
import android.text.style.*
import android.util.Log
import org.xml.sax.XMLReader
import java.util.*
import kotlin.reflect.KClass

/**
 * Some parts of this code are based on android.text.Html
 */
class HtmlTagHandler(private val mTextPaint: TextPaint) : Html.TagHandler {
    /**
     * Keeps track of lists (ol, ul). On bottom of Stack is the outermost list
     * and on top of Stack is the most nested list
     */
    internal var lists = Stack<String>()
    /**
     * List indentation in pixels. Nested lists use multiple of this.
     */
    /**
     * Tracks indexes of ordered lists so that after a nested list ends
     * we can continue with correct index of outer list
     */
    internal var olNextIndex = Stack<Int>()

    /**
     * Newer versions of the Android SDK's [Html.TagHandler] handles &lt;ul&gt; and &lt;li&gt;
     * tags itself which means they never get delegated to this class. We want to handle the tags
     * ourselves so before passing the string html into Html.fromHtml(), we can use this method to
     * replace the &lt;ul&gt; and &lt;li&gt; tags with tags of our own.
     *
     * @param html String containing HTML, for example: "**Hello world!**"
     * @return html with replaced  and  *  tags
     * @see [Specific Android SDK Commit](https://github.com/android/platform_frameworks_base/commit/8b36c0bbd1503c61c111feac939193c47f812190)
     */
    internal fun overrideTags(html: String?): String? {
        var html = html ?: return null

        html = html.replace("<ul", "<$UNORDERED_LIST")
        html = html.replace("</ul>", "</$UNORDERED_LIST>")
        html = html.replace("<ol", "<$ORDERED_LIST")
        html = html.replace("</ol>", "</$ORDERED_LIST>")
        html = html.replace("<li", "<$LIST_ITEM")
        html = html.replace("</li>", "</$LIST_ITEM>")

        return html
    }

    override fun handleTag(opening: Boolean, tag: String, output: Editable, xmlReader: XMLReader) {
        if (opening) {
            // opening tag
            Log.d(HtmlTextView.TAG, "opening, output: $output")

            when {
                tag.equals(UNORDERED_LIST, ignoreCase = true) -> lists.push(tag)
                tag.equals(ORDERED_LIST, ignoreCase = true) -> {
                    lists.push(tag)
                    olNextIndex.push(1)
                }
                tag.equals(LIST_ITEM, ignoreCase = true) -> {
                    if (output.isNotEmpty() && output[output.length - 1] != '\n') {
                        output.append("\n")
                    }
                    if (!lists.isEmpty()) {
                        val parentList = lists.peek()
                        when {
                            parentList.equals(ORDERED_LIST, ignoreCase = true) -> {
                                start(output, Ol())
                                olNextIndex.push(olNextIndex.pop() + 1)
                            }
                            parentList.equals(UNORDERED_LIST, ignoreCase = true) -> start(output, Ul())
                        }
                    }
                }
                tag.equals("code", ignoreCase = true) -> start(output, Code())
                tag.equals("center", ignoreCase = true) -> start(output, Center())
                tag.equals("s", ignoreCase = true) || tag.equals("strike", ignoreCase = true) -> start(output, Strike())
            }
        } else {
            // closing tag
            Log.d(HtmlTextView.TAG, "closing, output: $output")

            when {
                tag.equals(UNORDERED_LIST, ignoreCase = true) -> lists.pop()
                tag.equals(ORDERED_LIST, ignoreCase = true) -> {
                    lists.pop()
                    olNextIndex.pop()
                }
                tag.equals(LIST_ITEM, ignoreCase = true) -> if (!lists.isEmpty()) {
                    when {
                        lists.peek().equals(UNORDERED_LIST, ignoreCase = true) -> {
                            if (output.isNotEmpty() && output[output.length - 1] != '\n') {
                                output.append("\n")
                            }
                            // Nested BulletSpans increases distance between bullet and text, so we must prevent it.
                            var bulletMargin = indent
                            if (lists.size > 1) {
                                bulletMargin = indent - bullet.getLeadingMargin(true)
                                if (lists.size > 2) {
                                    // This get's more complicated when we add a LeadingMarginSpan into the same line:
                                    // we have also counter it's effect to BulletSpan
                                    bulletMargin -= (lists.size - 2) * listItemIndent
                                }
                            }
                            val newBullet = BulletSpan(bulletMargin)
                            end(output, Ul::class, false,
                                    LeadingMarginSpan.Standard(listItemIndent * (lists.size - 1)),
                                    newBullet)
                        }
                        lists.peek().equals(ORDERED_LIST, ignoreCase = true) -> {
                            if (output.isNotEmpty() && output[output.length - 1] != '\n') {
                                output.append("\n")
                            }
                            var numberMargin = listItemIndent * (lists.size - 1)
                            if (lists.size > 2) {
                                // Same as in ordered lists: counter the effect of nested Spans
                                numberMargin -= (lists.size - 2) * listItemIndent
                            }
                            val numberSpan = NumberSpan(mTextPaint, olNextIndex.lastElement() - 1)
                            end(output, Ol::class, false,
                                    LeadingMarginSpan.Standard(numberMargin),
                                    numberSpan)
                        }
                    }
                }
                tag.equals("code", ignoreCase = true) -> end(output, Code::class, false, TypefaceSpan("monospace"))
                tag.equals("center", ignoreCase = true) -> end(output, Center::class, true, AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER))
                tag.equals("s", ignoreCase = true) || tag.equals("strike", ignoreCase = true) -> end(output, Strike::class, false, StrikethroughSpan())
            }
        }
    }

    /**
     * Mark the opening tag by using private classes
     */
    private fun start(output: Editable, mark: Any) {
        val len = output.length
        output.setSpan(mark, len, len, Spannable.SPAN_MARK_MARK)

        Log.d(HtmlTextView.TAG, "len: $len")
    }

    /**
     * Modified from [Html]
     */
    private fun end(output: Editable, kind: KClass<*>, paragraphStyle: Boolean, vararg replaces: Any) {
        val obj = getLast(output, kind)
        // start of the tag
        val where = output.getSpanStart(obj)
        // end of the tag
        val len = output.length

        output.removeSpan(obj)

        if (where != len) {
            var thisLen = len
            // paragraph styles like AlignmentSpan need to end with a new line!
            if (paragraphStyle) {
                output.append("\n")
                thisLen++
            }
            for (replace in replaces) {
                output.setSpan(replace, where, thisLen, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            }

            Log.d(HtmlTextView.TAG, "where: $where")
            Log.d(HtmlTextView.TAG, "thisLen: $thisLen")
        }
    }

    private class Ul
    private class Ol
    private class Code
    private class Center
    private class Strike

    companion object {
        const val UNORDERED_LIST = "HTML_TEXTVIEW_ESCAPED_UL_TAG"
        const val ORDERED_LIST = "HTML_TEXTVIEW_ESCAPED_OL_TAG"
        const val LIST_ITEM = "HTML_TEXTVIEW_ESCAPED_LI_TAG"
        private const val indent = 10
        private const val listItemIndent = indent * 2
        private val bullet = BulletSpan(indent)

        /**
         * Get last marked position of a specific tag kind (private class)
         */
        private fun getLast(text: Editable, kind: KClass<*>): Any? {
            val objs = text.getSpans<Any>(0, text.length, kind.java as Class<Any>?)
            if (objs.isEmpty()) {
                return null
            } else {
                for (i in objs.size downTo 1) {
                    if (text.getSpanFlags(objs[i - 1]) == Spannable.SPAN_MARK_MARK) {
                        return objs[i - 1]
                    }
                }
                return null
            }
        }
    }

}
