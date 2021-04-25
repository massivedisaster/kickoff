package ${configs.packageName}.ui.widgets.htmltextview

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.text.*
import android.text.style.*
import androidx.core.content.ContextCompat
import org.ccil.cowan.tagsoup.HTMLSchema
import org.ccil.cowan.tagsoup.Parser
import org.xml.sax.*
import ${configs.packageName}.R
import java.io.IOException
import java.io.StringReader
import java.util.*
import java.util.regex.Pattern

object HtmlEnhancementParser {

    /**
     * Option for [.toHtml]: Wrap consecutive lines of text delimited by '\n'
     * inside &lt;p&gt; elements. [BulletSpan]s are ignored.
     */
    private const val TO_HTML_PARAGRAPH_LINES_CONSECUTIVE = 0x00000000

    /**
     * Option for [.toHtml]: Wrap each line of text delimited by '\n' inside a
     * &lt;p&gt; or a &lt;li&gt; element. This allows [ParagraphStyle]s attached to be
     * encoded as CSS styles within the corresponding &lt;p&gt; or &lt;li&gt; element.
     */
    private const val TO_HTML_PARAGRAPH_LINES_INDIVIDUAL = 0x00000001

    /**
     * Flag indicating that texts inside &lt;p&gt; elements will be separated from other texts with
     * one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_PARAGRAPH = 0x00000001

    /**
     * Flag indicating that texts inside &lt;h1&gt;~&lt;h6&gt; elements will be separated from
     * other texts with one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_HEADING = 0x00000002

    /**
     * Flag indicating that texts inside &lt;li&gt; elements will be separated from other texts
     * with one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_LIST_ITEM = 0x00000004

    /**
     * Flag indicating that texts inside &lt;ul&gt; elements will be separated from other texts
     * with one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_LIST = 0x00000008

    /**
     * Flag indicating that texts inside &lt;div&gt; elements will be separated from other texts
     * with one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_DIV = 0x00000010

    /**
     * Flag indicating that texts inside &lt;blockquote&gt; elements will be separated from other
     * texts with one newline character by default.
     */
    private const val FROM_HTML_SEPARATOR_LINE_BREAK_BLOCKQUOTE = 0x00000020

    /**
     * Flag indicating that CSS color values should be used instead of those defined in
     * [Color].
     */
    private const val FROM_HTML_OPTION_USE_CSS_COLORS = 0x00000100

    /**
     * Flags for [.fromHtml]: Separate block-level
     * elements with blank lines (two newline characters) in between. This is the legacy behavior
     * prior to N.
     */
    const val FROM_HTML_MODE_LEGACY = 0x00000000

    /**
     * Flags for [.fromHtml]: Separate block-level
     * elements with line breaks (single newline character) in between. This inverts the
     * [Spanned] to HTML string conversion done with the option
     * [.TO_HTML_PARAGRAPH_LINES_INDIVIDUAL].
     */
    const val FROM_HTML_MODE_COMPACT = (
            FROM_HTML_SEPARATOR_LINE_BREAK_PARAGRAPH
                    or FROM_HTML_SEPARATOR_LINE_BREAK_HEADING
                    or FROM_HTML_SEPARATOR_LINE_BREAK_LIST_ITEM
                    or FROM_HTML_SEPARATOR_LINE_BREAK_LIST
                    or FROM_HTML_SEPARATOR_LINE_BREAK_DIV
                    or FROM_HTML_SEPARATOR_LINE_BREAK_BLOCKQUOTE)

    /**
     * The bit which indicates if lines delimited by '\n' will be grouped into &lt;p&gt; elements.
     */
    private const val TO_HTML_PARAGRAPH_FLAG = 0x00000001

    /**
     * Returns displayable styled text from the provided HTML string with the legacy flags
     * [.FROM_HTML_MODE_LEGACY].
     *
     */
    @Deprecated("use {@link #fromHtml(String, int)} instead.", ReplaceWith("fromHtml(source, FROM_HTML_MODE_LEGACY, null, null, context, clickableTableSpan, drawTableLinkSpan)", "pt.nestle.nreceitas.ui.widgets.htmltextview.HtmlEnhancementParser.fromHtml", "pt.nestle.nreceitas.ui.widgets.htmltextview.HtmlEnhancementParser.FROM_HTML_MODE_LEGACY"))
    fun fromHtml(source: String, context: Context, clickableTableSpan: ClickableTableSpan, drawTableLinkSpan: DrawTableLinkSpan) = fromHtml(source, FROM_HTML_MODE_LEGACY, null, null, context, clickableTableSpan, drawTableLinkSpan)

    /**
     * Returns displayable styled text from the provided HTML string. Any &lt;img&gt; tags in the
     * HTML will display as a generic replacement image which your program can then go through and
     * replace with real images.
     *
     *
     *
     * This uses TagSoup to handle real HTML, including all of the brokenness found in the wild.
     */
    fun fromHtml(source: String, flags: Int, context: Context, clickableTableSpan: ClickableTableSpan, drawTableLinkSpan: DrawTableLinkSpan) = fromHtml(source, flags, null, null, context, clickableTableSpan, drawTableLinkSpan)

    /**
     * Returns displayable styled text from the provided HTML string. Any &lt;img&gt; tags in the
     * HTML will use the specified ImageGetter to request a representation of the image (use null
     * if you don't want this) and the specified TagHandler to handle unknown tags (specify null if
     * you don't want this).
     *
     *
     *
     * This uses TagSoup to handle real HTML, including all of the brokenness found in the wild.
     */
    fun fromHtml(source: String?, flags: Int, imageGetter: Html.ImageGetter?, tagHandler: Html.TagHandler?, context: Context, clickableTableSpan: ClickableTableSpan?, drawTableLinkSpan: DrawTableLinkSpan?): Spanned {
        val parser = Parser()
        try {
            parser.setProperty(Parser.schemaProperty, HtmlParser.schema)
        } catch (e: SAXNotRecognizedException) {
            // Should not happen.
            throw RuntimeException(e)
        } catch (e: SAXNotSupportedException) {
            // Should not happen.
            throw RuntimeException(e)
        }

        val converter = HtmlToSpannedConverter(source, imageGetter, tagHandler, parser, flags, context)
        converter.clickableTableSpan = clickableTableSpan
        converter.drawTableLinkSpan = drawTableLinkSpan
        return converter.convert()
    }


    @Deprecated("use {@link #toHtml(Spanned, int)} instead.", ReplaceWith("toHtml(text, TO_HTML_PARAGRAPH_LINES_CONSECUTIVE)", "pt.nestle.nreceitas.ui.widgets.htmltextview.HtmlEnhancementParser.toHtml", "pt.nestle.nreceitas.ui.widgets.htmltextview.HtmlEnhancementParser.TO_HTML_PARAGRAPH_LINES_CONSECUTIVE"))
    fun toHtml(text: Spanned) = toHtml(text, TO_HTML_PARAGRAPH_LINES_CONSECUTIVE)

    /**
     * Returns an HTML representation of the provided Spanned text. A best effort is
     * made to add HTML tags corresponding to spans. Also note that HTML metacharacters
     * (such as "&lt;" and "&amp;") within the input text are escaped.
     *
     * @param text   input text to convert
     * @param option one of [.TO_HTML_PARAGRAPH_LINES_CONSECUTIVE] or
     * [.TO_HTML_PARAGRAPH_LINES_INDIVIDUAL]
     * @return string containing input converted to HTML
     */
    fun toHtml(text: Spanned, option: Int): String {
        val out = StringBuilder()
        withinHtml(out, text, option)
        return out.toString()
    }

    /**
     * Returns an HTML escaped representation of the given plain text.
     */
    fun escapeHtml(text: CharSequence): String {
        val out = StringBuilder()
        withinStyle(out, text, 0, text.length)
        return out.toString()
    }

    private fun withinHtml(out: StringBuilder, text: Spanned, option: Int) {
        if (option and TO_HTML_PARAGRAPH_FLAG == TO_HTML_PARAGRAPH_LINES_CONSECUTIVE) {
            encodeTextAlignmentByDiv(out, text, option)
            return
        }

        withinDiv(out, text, 0, text.length, option)
    }

    private fun encodeTextAlignmentByDiv(out: StringBuilder, text: Spanned, option: Int) {
        val len = text.length

        var next: Int
        var i = 0
        while (i < len) {
            next = text.nextSpanTransition(i, len, ParagraphStyle::class.java)
            val style = text.getSpans<ParagraphStyle>(i, next, ParagraphStyle::class.java)
            var elements = " "
            var needDiv = false

            for (j in style.indices) {
                if (style[j] is AlignmentSpan) {
                    val align = (style[j] as AlignmentSpan).alignment
                    needDiv = true
                    elements = when (align) {
                        Layout.Alignment.ALIGN_CENTER -> "align=\"center\" $elements"
                        Layout.Alignment.ALIGN_OPPOSITE -> "align=\"right\" $elements"
                        else -> "align=\"left\" $elements"
                    }
                }
            }
            if (needDiv) {
                out.append("<div ").append(elements).append(">")
            }

            withinDiv(out, text, i, next, option)

            if (needDiv) {
                out.append("</div>")
            }
            i = next
        }
    }

    private fun withinDiv(out: StringBuilder, text: Spanned, start: Int, end: Int, option: Int) {
        var next: Int
        var i = start
        while (i < end) {
            next = text.nextSpanTransition(i, end, QuoteSpan::class.java)
            val quotes = text.getSpans<QuoteSpan>(i, next, QuoteSpan::class.java)

            for (quote in quotes) {
                out.append("<blockquote>")
            }

            withinBlockquote(out, text, i, next, option)

            for (quote in quotes) {
                out.append("</blockquote>\n")
            }
            i = next
        }
    }

    private fun getTextDirection(text: Spanned, start: Int, end: Int) = if (TextDirectionHeuristics.FIRSTSTRONG_LTR.isRtl(text, start, end - start)) " dir=\"rtl\"" else " dir=\"ltr\""

    private fun getTextStyles(text: Spanned, start: Int, end: Int, forceNoVerticalMargin: Boolean, includeTextAlign: Boolean): String {
        var margin: String? = null
        var textAlign: String? = null

        if (forceNoVerticalMargin) {
            margin = "margin-top:0; margin-bottom:0;"
        }
        if (includeTextAlign) {
            val alignmentSpans = text.getSpans(start, end, AlignmentSpan::class.java)

            // Only use the last AlignmentSpan with flag SPAN_PARAGRAPH
            for (i in alignmentSpans.indices.reversed()) {
                val s = alignmentSpans[i]
                if (text.getSpanFlags(s) and Spanned.SPAN_PARAGRAPH == Spanned.SPAN_PARAGRAPH) {
                    textAlign = when (s.alignment) {
                        Layout.Alignment.ALIGN_NORMAL -> "text-align:start;"
                        Layout.Alignment.ALIGN_CENTER -> "text-align:center;"
                        Layout.Alignment.ALIGN_OPPOSITE -> "text-align:end;"
                    }
                    break
                }
            }
        }

        if (margin == null && textAlign == null) {
            return ""
        }

        val style = StringBuilder(" style=\"")
        when {
            margin != null && textAlign != null -> style.append(margin).append(" ").append(textAlign)
            margin != null -> style.append(margin)
            textAlign != null -> style.append(textAlign)
        }

        return style.append("\"").toString()
    }

    private fun withinBlockquote(out: StringBuilder, text: Spanned, start: Int, end: Int, option: Int) {
        if (option and TO_HTML_PARAGRAPH_FLAG == TO_HTML_PARAGRAPH_LINES_CONSECUTIVE) {
            withinBlockquoteConsecutive(out, text, start, end)
        } else {
            withinBlockquoteIndividual(out, text, start, end)
        }
    }

    private fun withinBlockquoteIndividual(out: StringBuilder, text: Spanned, start: Int, end: Int) {
        var isInList = false
        var next: Int
        var i = start
        while (i <= end) {
            next = TextUtils.indexOf(text, '\n', i, end)
            if (next < 0) {
                next = end
            }

            if (next == i) {
                if (isInList) {
                    // Current paragraph is no longer a list item; close the previously opened list
                    isInList = false
                    out.append("</ul>\n")
                }
                out.append("<br>\n")
            } else {
                var isListItem = false
                val paragraphStyles = text.getSpans(i, next, ParagraphStyle::class.java)
                for (paragraphStyle in paragraphStyles) {
                    val spanFlags = text.getSpanFlags(paragraphStyle)
                    if (spanFlags and Spanned.SPAN_PARAGRAPH == Spanned.SPAN_PARAGRAPH && paragraphStyle is BulletSpan) {
                        isListItem = true
                        break
                    }
                }

                if (isListItem && !isInList) {
                    // Current paragraph is the first item in a list
                    isInList = true
                    out.append("<ul").append(getTextStyles(text, i, next, true, false)).append(">\n")
                }

                if (isInList && !isListItem) {
                    // Current paragraph is no longer a list item; close the previously opened list
                    isInList = false
                    out.append("</ul>\n")
                }

                val tagType = if (isListItem) "li" else "p"
                out.append("<").append(tagType)
                        .append(getTextDirection(text, i, next))
                        .append(getTextStyles(text, i, next, !isListItem, true))
                        .append(">")

                withinParagraph(out, text, i, next)

                out.append("</")
                out.append(tagType)
                out.append(">\n")

                if (next == end && isInList) {
                    isInList = false
                    out.append("</ul>\n")
                }
            }

            next++
            i = next
        }
    }

    private fun withinBlockquoteConsecutive(out: StringBuilder, text: Spanned, start: Int, end: Int) {
        out.append("<p").append(getTextDirection(text, start, end)).append(">")

        var next: Int
        var i = start
        while (i < end) {
            next = TextUtils.indexOf(text, '\n', i, end)
            if (next < 0) {
                next = end
            }

            var nl = 0

            while (next < end && text[next] == '\n') {
                nl++
                next++
            }

            withinParagraph(out, text, i, next - nl)

            if (nl == 1) {
                out.append("<br>\n")
            } else {
                for (j in 2 until nl) {
                    out.append("<br>")
                }
                if (next != end) {
                    /* Paragraph should be closed and reopened */
                    out.append("</p>\n")
                    out.append("<p").append(getTextDirection(text, start, end)).append(">")
                }
            }
            i = next
        }

        out.append("</p>\n")
    }

    private fun withinParagraph(out: StringBuilder, text: Spanned, start: Int, end: Int) {
        var next: Int
        var i = start
        while (i < end) {
            next = text.nextSpanTransition(i, end, CharacterStyle::class.java)
            val style = text.getSpans(i, next, CharacterStyle::class.java)

            for (j in style.indices) {
                if (style[j] is StyleSpan) {
                    val s = (style[j] as StyleSpan).style

                    if (s and Typeface.BOLD != 0) {
                        out.append("<b>")
                    }
                    if (s and Typeface.ITALIC != 0) {
                        out.append("<i>")
                    }
                }
                if (style[j] is TypefaceSpan) {
                    val s = (style[j] as TypefaceSpan).family

                    if ("monospace" == s) {
                        out.append("<tt>")
                    }
                }
                if (style[j] is SuperscriptSpan) {
                    out.append("<sup>")
                }
                if (style[j] is SubscriptSpan) {
                    out.append("<sub>")
                }
                if (style[j] is UnderlineSpan) {
                    out.append("<u>")
                }
                if (style[j] is StrikethroughSpan) {
                    out.append("<span style=\"text-decoration:line-through;\">")
                }
                if (style[j] is URLSpan) {
                    out.append("<a href=\"")
                    out.append((style[j] as URLSpan).url)
                    out.append("\">")
                }
                if (style[j] is ImageSpan) {
                    out.append("<img src=\"")
                    out.append((style[j] as ImageSpan).source)
                    out.append("\">")

                    // Don't output the dummy character underlying the image.
                    i = next
                }
                if (style[j] is AbsoluteSizeSpan) {
                    val s = style[j] as AbsoluteSizeSpan
                    val sizeDip = s.size.toFloat()
                    /*if (!s.getDip()) {
                        Application application = ActivityThread.currentApplication();
                        sizeDip /= application.getResources().getDisplayMetrics().density;
                    }*/

                    // px in CSS is the equivalance of dip in Android
                    out.append(String.format("<span style=\"font-size:%.0fpx\";>", sizeDip))
                }
                if (style[j] is RelativeSizeSpan) {
                    val sizeEm = (style[j] as RelativeSizeSpan).sizeChange
                    out.append(String.format("<span style=\"font-size:%.2fem;\">", sizeEm))
                }
                if (style[j] is ForegroundColorSpan) {
                    val color = (style[j] as ForegroundColorSpan).foregroundColor
                    out.append(String.format("<span style=\"color:#%06X;\">", 0xFFFFFF and color))
                }
                if (style[j] is BackgroundColorSpan) {
                    val color = (style[j] as BackgroundColorSpan).backgroundColor
                    out.append(String.format("<span style=\"background-color:#%06X;\">", 0xFFFFFF and color))
                }
            }

            withinStyle(out, text, i, next)

            for (j in style.indices.reversed()) {
                if (style[j] is BackgroundColorSpan) {
                    out.append("</span>")
                }
                if (style[j] is ForegroundColorSpan) {
                    out.append("</span>")
                }
                if (style[j] is RelativeSizeSpan) {
                    out.append("</span>")
                }
                if (style[j] is AbsoluteSizeSpan) {
                    out.append("</span>")
                }
                if (style[j] is URLSpan) {
                    out.append("</a>")
                }
                if (style[j] is StrikethroughSpan) {
                    out.append("</span>")
                }
                if (style[j] is UnderlineSpan) {
                    out.append("</u>")
                }
                if (style[j] is SubscriptSpan) {
                    out.append("</sub>")
                }
                if (style[j] is SuperscriptSpan) {
                    out.append("</sup>")
                }
                if (style[j] is TypefaceSpan) {
                    val s = (style[j] as TypefaceSpan).family

                    if (s == "monospace") {
                        out.append("</tt>")
                    }
                }
                if (style[j] is StyleSpan) {
                    val s = (style[j] as StyleSpan).style

                    if (s and Typeface.BOLD != 0) {
                        out.append("</b>")
                    }
                    if (s and Typeface.ITALIC != 0) {
                        out.append("</i>")
                    }
                }
            }
            i = next
        }
    }

    private fun withinStyle(out: StringBuilder, text: CharSequence, start: Int, end: Int) {
        var i = start
        while (i < end) {
            val c = text[i]

            when {
                c == '<' -> out.append("&lt;")
                c == '>' -> out.append("&gt;")
                c == '&' -> out.append("&amp;")
                c.toInt() in 0xD800..0xDFFF -> if (c.toInt() < 0xDC00 && i + 1 < end) {
                    val d = text[i + 1]
                    if (d.toInt() in 0xDC00..0xDFFF) {
                        i++
                        val codePoint = 0x010000 or (c.toInt() - 0xD800 shl 10) or d.toInt() - 0xDC00
                        out.append("&#").append(codePoint).append(";")
                    }
                }
                c.toInt() > 0x7E || c < ' ' -> out.append("&#").append(c.toInt()).append(";")
                c == ' ' -> {
                    while (i + 1 < end && text[i + 1] == ' ') {
                        out.append("&nbsp;")
                        i++
                    }

                    out.append(' ')
                }
                else -> out.append(c)
            }
            i++
        }
    }

    /**
     * Lazy initialization holder for HTML parser. This class will
     * a) be preloaded by the zygote, or b) not loaded until absolutely
     * necessary.
     */
    private object HtmlParser {
        internal val schema = HTMLSchema()
    }
}

internal class HtmlToSpannedConverter(private val source: String?, private val imageGetter: Html.ImageGetter?, private val tagHandler: Html.TagHandler?, parser: Parser, private val flags: Int, private val context: Context) : ContentHandler {

    /**
     * Running HTML table string based off of the root table tag. Root table tag being the tag which
     * isn't embedded within any other table tag. Example:
     *
     * <table>
     * ...
     * <table>
     * ...
    </table> *
     * ...
    </table> *
     *
     */
    private var tableHtmlBuilder = StringBuilder()
    /**
     * Tells us which level of table tag we're on; ultimately used to find the root table tag.
     */
    var tableTagLevel = 0
    var clickableTableSpan: ClickableTableSpan? = null
    var drawTableLinkSpan: DrawTableLinkSpan? = null
    private val reader: XMLReader
    private val spannableStringBuilder: SpannableStringBuilder = SpannableStringBuilder()

    private val textAlignPattern: Pattern?
        get() {
            if (sTextAlignPattern == null) {
                sTextAlignPattern = Pattern.compile("(?:\\s+|\\A)text-align\\s*:\\s*(\\S*)\\b")
            }
            return sTextAlignPattern
        }

    private val foregroundColorPattern: Pattern?
        get() {
            if (sForegroundColorPattern == null) {
                sForegroundColorPattern = Pattern.compile(
                        "(?:\\s+|\\A)color\\s*:\\s*(\\S*)\\b")
            }
            return sForegroundColorPattern
        }

    private val backgroundColorPattern: Pattern?
        get() {
            if (sBackgroundColorPattern == null) {
                sBackgroundColorPattern = Pattern.compile(
                        "(?:\\s+|\\A)background(?:-color)?\\s*:\\s*(\\S*)\\b")
            }
            return sBackgroundColorPattern
        }

    private val textDecorationPattern: Pattern?
        get() {
            if (sTextDecorationPattern == null) {
                sTextDecorationPattern = Pattern.compile(
                        "(?:\\s+|\\A)text-decoration\\s*:\\s*(\\S*)\\b")
            }
            return sTextDecorationPattern
        }

    private val marginParagraph: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_PARAGRAPH)

    private val marginHeading: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_HEADING)

    private val marginListItem: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_LIST_ITEM)

    private val marginList: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_LIST)

    private val marginDiv: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_DIV)

    private val marginBlockquote: Int
        get() = getMargin(Html.FROM_HTML_SEPARATOR_LINE_BREAK_BLOCKQUOTE)

    init {
        reader = parser
    }

    private fun appendNewlines(text: Editable, minNewline: Int) {
        val len = text.length

        if (len == 0) {
            return
        }

        var existingNewlines = 0
        var i = len - 1
        while (i >= 0 && text[i] == '\n') {
            existingNewlines++
            i--
        }

        for (j in existingNewlines until minNewline) {
            text.append("\n")
        }
    }

    private fun startBlockElement(text: Editable, attributes: Attributes, margin: Int) {
        if (margin > 0) {
            appendNewlines(text, margin)
            start(text, Newline(margin))
        }

        val style = attributes.getValue("", "style")
        if (style != null) {
            val m = textAlignPattern!!.matcher(style)
            if (m.find()) {
                val alignment = m.group(1)
                when {
                    alignment.equals("start", ignoreCase = true) -> start(text, Alignment(Layout.Alignment.ALIGN_NORMAL))
                    alignment.equals("center", ignoreCase = true) -> start(text, Alignment(Layout.Alignment.ALIGN_CENTER))
                    alignment.equals("end", ignoreCase = true) -> start(text, Alignment(Layout.Alignment.ALIGN_OPPOSITE))
                }
            }
        }
    }

    private fun endBlockElement(text: Editable) {
        val n = getLast(text, Newline::class.java)
        if (n != null) {
            appendNewlines(text, n.mNumNewlines)
            text.removeSpan(n)
        }

        val a = getLast(text, Alignment::class.java)
        if (a != null) {
            setSpanFromMark(text, a, AlignmentSpan.Standard(a.mAlignment))
        }
    }

    private fun handleBr(text: Editable) {
        text.append('\n')
    }

    private fun endLi(text: Editable) {
        endCssStyle(text)
        endBlockElement(text)
        end(text, Bullet::class.java, BulletSpan())
    }

    private fun endBlockquote(text: Editable) {
        endBlockElement(text)
        end(text, Blockquote::class.java, QuoteSpan())
    }

    private fun endHeading(text: Editable) {
        // RelativeSizeSpan and StyleSpan are CharacterStyles
        // Their ranges should not include the newlines at the end
        val h = getLast(text, Heading::class.java)
        if (h != null) {
            setSpanFromMark(text, h, RelativeSizeSpan(HEADING_SIZES[h.mLevel]),
                    StyleSpan(Typeface.BOLD))
        }

        endBlockElement(text)
    }

    private fun <T> getLast(text: Spanned, kind: Class<T>): T? {
        /*
         * This knows that the last returned object from getSpans()
         * will be the most recently added.
         */
        val objs = text.getSpans(0, text.length, kind)

        return if (objs.isEmpty()) {
            null
        } else {
            objs[objs.size - 1]
        }
    }

    private fun setSpanFromMark(text: Spannable, mark: Any, vararg spans: Any) {
        val where = text.getSpanStart(mark)
        text.removeSpan(mark)
        val len = text.length
        if (where != len) {
            for (span in spans) {
                text.setSpan(span, where, len, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            }
        }
    }

    private fun start(text: Editable, mark: Any) {
        // start of the tag
        val len = text.length
        text.setSpan(mark, len, len, Spannable.SPAN_INCLUSIVE_EXCLUSIVE)
    }

    private fun end(text: Editable, kind: Class<*>, repl: Any?, vararg replaces: Any) {
        val obj = getLast(text, kind)
        // start of the tag
        val where = text.getSpanStart(obj)
        // end of the tag
        val len = text.length

        // If we're in a table, then we need to store the raw HTML for later
        when {
            tableTagLevel > 0 -> {
                val extractedSpanText = extractSpanText(text, kind)
                tableHtmlBuilder.append(extractedSpanText)
            }
            obj != null && repl != null -> setSpanFromMark(text, obj, repl)
        }

        text.removeSpan(obj)

        if (where != len) {
            for (replace in replaces) {
                text.setSpan(replace, where, len, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            }
        }
    }

    /**
     * Returns the text contained within a span and deletes it from the output string
     */
    private fun extractSpanText(output: Editable, kind: Class<*>): CharSequence {
        val obj = getLast(output, kind)
        // start of the tag
        val where = output.getSpanStart(obj)
        // end of the tag
        val len = output.length

        if (where > 0) {
            val extractedSpanText = output.subSequence(where, len)
            output.delete(where, len)
            return extractedSpanText
        }

        return ""
    }

    private fun endCssStyle(text: Editable) {
        val s = getLast(text, Strikethrough::class.java)
        if (s != null) {
            setSpanFromMark(text, s, StrikethroughSpan())
        }

        val b = getLast(text, Background::class.java)
        if (b != null) {
            setSpanFromMark(text, b, BackgroundColorSpan(b.mBackgroundColor))
        }

        val f = getLast(text, Foreground::class.java)
        if (f != null) {
            setSpanFromMark(text, f, ForegroundColorSpan(f.mForegroundColor))
        }
    }

    private fun startImg(text: Editable, attributes: Attributes, img: Html.ImageGetter?) {
        val src = attributes.getValue("", "src")
        var d: Drawable? = null

        if (img != null) {
            d = img.getDrawable(src)
        }

        if (d == null) {
            d = ContextCompat.getDrawable(context, R.drawable.ic_error)
            d!!.setBounds(0, 0, d.intrinsicWidth, d.intrinsicHeight)
        }

        val len = text.length
        text.append("\uFFFC")

        text.setSpan(ImageSpan(d, src), len, text.length,
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    }

    private fun endFont(text: Editable) {
        val font = getLast(text, Font::class.java)
        if (font != null) {
            setSpanFromMark(text, font, TypefaceSpan(font.mFace))
        }

        val foreground = getLast(text, Foreground::class.java)
        if (foreground != null) {
            setSpanFromMark(text, foreground, ForegroundColorSpan(foreground.mForegroundColor))
        }
    }

    private fun startA(text: Editable, attributes: Attributes) {
        val href = attributes.getValue("", "href")
        start(text, Href(href))
    }

    private fun endA(text: Editable) {
        val h = getLast(text, Href::class.java)
        if (h != null && h.mHref != null) {
            setSpanFromMark(text, h, URLSpan(h.mHref))
        }
    }

    fun convert(): Spanned {
        reader.contentHandler = this
        try {
            reader.parse(InputSource(StringReader(source)))
        } catch (e: IOException) {
            // We are reading from a string. There should not be IO problems.
            throw RuntimeException(e)
        } catch (e: SAXException) {
            // TagSoup doesn't throw parse exceptions.
            throw RuntimeException(e)
        }

        // Fix flags and range for paragraph-type markup.
        val obj = spannableStringBuilder.getSpans<ParagraphStyle>(0, spannableStringBuilder.length, ParagraphStyle::class.java)
        for (i in obj.indices) {
            val start = spannableStringBuilder.getSpanStart(obj[i])
            var end = spannableStringBuilder.getSpanEnd(obj[i])

            // If the last line of the range is blank, back off by one.
            if (end - 2 >= 0 && spannableStringBuilder[end - 1] == '\n' && spannableStringBuilder[end - 2] == '\n') {
                end--
            }

            if (end == start) {
                spannableStringBuilder.removeSpan(obj[i])
            } else {
                spannableStringBuilder.setSpan(obj[i], start, end, Spannable.SPAN_PARAGRAPH)
            }
        }

        return spannableStringBuilder
    }

    private fun handleStartTag(tag: String, attributes: Attributes) {
        when {
            tag.equals("br", ignoreCase = true) -> {
                // We don't need to handle this. TagSoup will ensure that there's a </br> for each <br>
                // so we can safely emit the linebreaks when we handle the close tag.
            }
            tag.equals("p", ignoreCase = true) -> {
                startBlockElement(spannableStringBuilder, attributes, marginParagraph)
                startCssStyle(spannableStringBuilder, attributes)
            }
            tag.equals("ul", ignoreCase = true) -> startBlockElement(spannableStringBuilder, attributes, marginList)
            tag.equals("li", ignoreCase = true) -> startLi(spannableStringBuilder, attributes)
            tag.equals("div", ignoreCase = true) -> startBlockElement(spannableStringBuilder, attributes, marginDiv)
            tag.equals("span", ignoreCase = true) -> startCssStyle(spannableStringBuilder, attributes)
            tag.equals("strong", ignoreCase = true) -> start(spannableStringBuilder, Bold())
            tag.equals("b", ignoreCase = true) -> start(spannableStringBuilder, Bold())
            tag.equals("em", ignoreCase = true) -> start(spannableStringBuilder, Italic())
            tag.equals("cite", ignoreCase = true) -> start(spannableStringBuilder, Italic())
            tag.equals("dfn", ignoreCase = true) -> start(spannableStringBuilder, Italic())
            tag.equals("i", ignoreCase = true) -> start(spannableStringBuilder, Italic())
            tag.equals("big", ignoreCase = true) -> start(spannableStringBuilder, Big())
            tag.equals("small", ignoreCase = true) -> start(spannableStringBuilder, Small())
            tag.equals("font", ignoreCase = true) -> startFont(spannableStringBuilder, attributes)
            tag.equals("blockquote", ignoreCase = true) -> startBlockquote(spannableStringBuilder, attributes)
            tag.equals("tt", ignoreCase = true) -> start(spannableStringBuilder, Monospace())
            tag.equals("a", ignoreCase = true) -> if (tableTagLevel == 0) {
                startA(spannableStringBuilder, attributes)
            } else {
                start(spannableStringBuilder, A())
            }
            tag.equals("u", ignoreCase = true) -> start(spannableStringBuilder, Underline())
            tag.equals("del", ignoreCase = true) -> start(spannableStringBuilder, Strikethrough())
            tag.equals("s", ignoreCase = true) -> start(spannableStringBuilder, Strikethrough())
            tag.equals("strike", ignoreCase = true) -> start(spannableStringBuilder, Strikethrough())
            tag.equals("sup", ignoreCase = true) -> start(spannableStringBuilder, Super())
            tag.equals("sub", ignoreCase = true) -> start(spannableStringBuilder, Sub())
            tag.length == 2 &&
                    Character.toLowerCase(tag[0]) == 'h' &&
                    tag[1] >= '1' && tag[1] <= '6' -> startHeading(spannableStringBuilder, attributes, tag[1] - '1')
            tag.equals("img", ignoreCase = true) -> startImg(spannableStringBuilder, attributes, imageGetter)
            tag.equals("table", ignoreCase = true) -> {
                start(spannableStringBuilder, Table())
                if (tableTagLevel == 0) {
                    tableHtmlBuilder = StringBuilder()
                    // We need some text for the table to be replaced by the span because
                    // the other tags will remove their text when their text is extracted
                    spannableStringBuilder.append("table placeholder")
                }

                tableTagLevel++
            }
            tag.equals("tr", ignoreCase = true) -> start(spannableStringBuilder, Tr())
            tag.equals("th", ignoreCase = true) -> start(spannableStringBuilder, Th())
            tag.equals("td", ignoreCase = true) -> start(spannableStringBuilder, Td())
            else -> tagHandler?.handleTag(true, tag, spannableStringBuilder, reader)
        }

        storeTags(spannableStringBuilder, true, tag, attributes)
    }

    private fun handleEndTag(tag: String) {
        when {
            tag.equals("br", ignoreCase = true) -> handleBr(spannableStringBuilder)
            tag.equals("p", ignoreCase = true) -> {
                endCssStyle(spannableStringBuilder)
                endBlockElement(spannableStringBuilder)
            }
            tag.equals("ul", ignoreCase = true) -> endBlockElement(spannableStringBuilder)
            tag.equals("li", ignoreCase = true) -> endLi(spannableStringBuilder)
            tag.equals("div", ignoreCase = true) -> endBlockElement(spannableStringBuilder)
            tag.equals("span", ignoreCase = true) -> endCssStyle(spannableStringBuilder)
            tag.equals("strong", ignoreCase = true) -> end(spannableStringBuilder, Bold::class.java, StyleSpan(Typeface.BOLD))
            tag.equals("b", ignoreCase = true) -> end(spannableStringBuilder, Bold::class.java, StyleSpan(Typeface.BOLD))
            tag.equals("em", ignoreCase = true) -> end(spannableStringBuilder, Italic::class.java, StyleSpan(Typeface.ITALIC))
            tag.equals("cite", ignoreCase = true) -> end(spannableStringBuilder, Italic::class.java, StyleSpan(Typeface.ITALIC))
            tag.equals("dfn", ignoreCase = true) -> end(spannableStringBuilder, Italic::class.java, StyleSpan(Typeface.ITALIC))
            tag.equals("i", ignoreCase = true) -> end(spannableStringBuilder, Italic::class.java, StyleSpan(Typeface.ITALIC))
            tag.equals("big", ignoreCase = true) -> end(spannableStringBuilder, Big::class.java, RelativeSizeSpan(1.25f))
            tag.equals("small", ignoreCase = true) -> end(spannableStringBuilder, Small::class.java, RelativeSizeSpan(0.8f))
            tag.equals("font", ignoreCase = true) -> endFont(spannableStringBuilder)
            tag.equals("blockquote", ignoreCase = true) -> endBlockquote(spannableStringBuilder)
            tag.equals("tt", ignoreCase = true) -> end(spannableStringBuilder, Monospace::class.java, TypefaceSpan("monospace"))
            tag.equals("a", ignoreCase = true) -> if (tableTagLevel == 0) {
                endA(spannableStringBuilder)
            } else {
                end(spannableStringBuilder, A::class.java, null)
            }
            tag.equals("u", ignoreCase = true) -> end(spannableStringBuilder, Underline::class.java, UnderlineSpan())
            tag.equals("del", ignoreCase = true) -> end(spannableStringBuilder, Strikethrough::class.java, StrikethroughSpan())
            tag.equals("s", ignoreCase = true) -> end(spannableStringBuilder, Strikethrough::class.java, StrikethroughSpan())
            tag.equals("strike", ignoreCase = true) -> end(spannableStringBuilder, Strikethrough::class.java, StrikethroughSpan())
            tag.equals("sup", ignoreCase = true) -> end(spannableStringBuilder, Super::class.java, SuperscriptSpan())
            tag.equals("sub", ignoreCase = true) -> end(spannableStringBuilder, Sub::class.java, SubscriptSpan())
            tag.length == 2 &&
                    Character.toLowerCase(tag[0]) == 'h' &&
                    tag[1] >= '1' && tag[1] <= '6' -> endHeading(spannableStringBuilder)
            tag.equals("table", ignoreCase = true) -> {
                tableTagLevel--

                // When we're back at the root-level table
                if (tableTagLevel == 0) {
                    tableHtmlBuilder
                            .append("</")
                            .append(tag.toLowerCase())
                            .append(">")
                    val tableHtml = tableHtmlBuilder.toString()

                    var myClickableTableSpan: ClickableTableSpan? = null
                    if (clickableTableSpan != null) {
                        myClickableTableSpan = clickableTableSpan!!.newInstance(context)
                        myClickableTableSpan.tableHtml = tableHtml
                    }

                    var myDrawTableLinkSpan: DrawTableLinkSpan? = null
                    if (drawTableLinkSpan != null) {
                        myDrawTableLinkSpan = drawTableLinkSpan!!.newInstance()
                    }

                    end(spannableStringBuilder, Table::class.java, myDrawTableLinkSpan, myClickableTableSpan!!)
                } else {
                    end(spannableStringBuilder, Table::class.java, null)
                }
            }
            tag.equals("tr", ignoreCase = true) -> end(spannableStringBuilder, Tr::class.java, null)
            tag.equals("th", ignoreCase = true) -> end(spannableStringBuilder, Th::class.java, null)
            tag.equals("td", ignoreCase = true) -> end(spannableStringBuilder, Td::class.java, null)
            else -> tagHandler?.handleTag(false, tag, spannableStringBuilder, reader)
        }

        storeTags(spannableStringBuilder, false, tag, null)
    }

    /**
     * If we're arriving at a table tag or are already within a table tag, then we should store it
     * the raw HTML for our ClickableTableSpan
     */
    private fun storeTags(text: SpannableStringBuilder, opening: Boolean, tag: String, attributes: Attributes?) {
        if (tableTagLevel > 0 || tag.equals("table", ignoreCase = true)) {
            tableHtmlBuilder.append("<")
            if (!opening) {
                tableHtmlBuilder.append("/")
            }

            tableHtmlBuilder.append(tag.toLowerCase())

            if (attributes != null) {
                val len = attributes.length

                for (i in 0 until len) {
                    tableHtmlBuilder.append(" ")
                            .append(attributes.getLocalName(i))
                            .append("=")
                            .append("\"")
                            .append(attributes.getValue(i))
                            .append("\"")
                }
            }

            tableHtmlBuilder.append(">")

            if (!opening && !tag.equals("table", ignoreCase = true)
                    && !tag.equals("tr", ignoreCase = true)
                    && !tag.equals("td", ignoreCase = true)) {
                val extractedSpanText = extractSpanText(text, Td::class.java)
                tableHtmlBuilder.append(extractedSpanText)
            }
        }
    }

    /**
     * Returns the minimum number of newline characters needed before and after a given block-level
     * element.
     *
     * @param flag the corresponding option flag defined in [Html] of a block-level element
     */
    private fun getMargin(flag: Int) = if (flag and flags != 0) 1 else 2

    private fun startLi(text: Editable, attributes: Attributes) {
        startBlockElement(text, attributes, marginListItem)
        start(text, Bullet())
        startCssStyle(text, attributes)
    }

    private fun startBlockquote(text: Editable, attributes: Attributes) {
        startBlockElement(text, attributes, marginBlockquote)
        start(text, Blockquote())
    }

    private fun startHeading(text: Editable, attributes: Attributes, level: Int) {
        startBlockElement(text, attributes, marginHeading)
        start(text, Heading(level))
    }

    private fun startCssStyle(text: Editable, attributes: Attributes) {
        val style = attributes.getValue("", "style")
        if (style != null) {
            var m = foregroundColorPattern!!.matcher(style)
            if (m.find()) {
                val c = getHtmlColor(m.group(1))
                if (c != -1) {
                    start(text, Foreground(c or -0x1000000))
                }
            }

            m = backgroundColorPattern!!.matcher(style)
            if (m.find()) {
                val c = getHtmlColor(m.group(1))
                if (c != -1) {
                    start(text, Background(c or -0x1000000))
                }
            }

            m = textDecorationPattern!!.matcher(style)
            if (m.find()) {
                val textDecoration = m.group(1)
                if (textDecoration.equals("line-through", ignoreCase = true)) {
                    start(text, Strikethrough())
                }
            }
        }
    }

    private fun startFont(text: Editable, attributes: Attributes) {
        val color = attributes.getValue("", "color")
        val face = attributes.getValue("", "face")

        if (!TextUtils.isEmpty(color)) {
            val c = getHtmlColor(color)
            if (c != -1) {
                start(text, Foreground(c or -0x1000000))
            }
        }

        if (!TextUtils.isEmpty(face)) {
            start(text, Font(face))
        }
    }

    private fun getHtmlColor(color: String): Int {
        if (flags and Html.FROM_HTML_OPTION_USE_CSS_COLORS == Html.FROM_HTML_OPTION_USE_CSS_COLORS) {
            val i = sColorMap[color.toLowerCase(Locale.US)]
            if (i != null) {
                return i
            }
        }
        return MyColor.getHtmlColor(color)
    }

    override fun setDocumentLocator(locator: Locator) {}

    @Throws(SAXException::class)
    override fun startDocument() {
    }

    @Throws(SAXException::class)
    override fun endDocument() {
    }

    @Throws(SAXException::class)
    override fun startPrefixMapping(prefix: String, uri: String) {
    }

    @Throws(SAXException::class)
    override fun endPrefixMapping(prefix: String) {
    }

    @Throws(SAXException::class)
    override fun startElement(uri: String, localName: String, qName: String, attributes: Attributes) {
        handleStartTag(localName, attributes)
    }

    @Throws(SAXException::class)
    override fun endElement(uri: String, localName: String, qName: String) {
        handleEndTag(localName)
    }

    @Throws(SAXException::class)
    override fun characters(ch: CharArray, start: Int, length: Int) {
        val sb = StringBuilder()

        /*
         * Ignore whitespace that immediately follows other whitespace;
         * newlines count as spaces.
         */

        for (i in 0 until length) {
            val c = ch[i + start]

            if (c == ' ' || c == '\n') {
                val pred: Char
                var len = sb.length

                if (len == 0) {
                    len = spannableStringBuilder.length

                    pred = if (len == 0) {
                        '\n'
                    } else {
                        spannableStringBuilder[len - 1]
                    }
                } else {
                    pred = sb[len - 1]
                }

                if (pred != ' ' && pred != '\n') {
                    sb.append(' ')
                }
            } else {
                sb.append(c)
            }
        }

        spannableStringBuilder.append(sb)
    }

    @Throws(SAXException::class)
    override fun ignorableWhitespace(ch: CharArray, start: Int, length: Int) {
    }

    @Throws(SAXException::class)
    override fun processingInstruction(target: String, data: String) {
    }

    @Throws(SAXException::class)
    override fun skippedEntity(name: String) {
    }

    private class Bold
    private class Italic
    private class Underline
    private class Strikethrough
    private class Big
    private class Small
    private class Monospace
    private class Blockquote
    private class Super
    private class Sub
    private class Bullet
    private class Font(var mFace: String)
    private class Href(var mHref: String?)
    private class Foreground(internal val mForegroundColor: Int)
    private class Background(internal val mBackgroundColor: Int)
    private class Heading(internal val mLevel: Int)
    private class Newline(internal val mNumNewlines: Int)
    private class Alignment(internal val mAlignment: Layout.Alignment)
    private class Table
    private class Tr
    private class Th
    private class Td
    private class A

    companion object {

        private val HEADING_SIZES = floatArrayOf(1.5f, 1.4f, 1.3f, 1.2f, 1.1f, 1f)
        /**
         * Name-value mapping of HTML/CSS colors which have different values in [Color].
         */
        private val sColorMap: MutableMap<String, Int>
        private var sTextAlignPattern: Pattern? = null
        private var sForegroundColorPattern: Pattern? = null
        private var sBackgroundColorPattern: Pattern? = null
        private var sTextDecorationPattern: Pattern? = null

        init {
            sColorMap = HashMap()
            sColorMap["darkgray"] = -0x565657
            sColorMap["gray"] = -0x7f7f80
            sColorMap["lightgray"] = -0x2c2c2d
            sColorMap["darkgrey"] = -0x565657
            sColorMap["grey"] = -0x7f7f80
            sColorMap["lightgrey"] = -0x2c2c2d
            sColorMap["green"] = -0xff8000
        }
    }

}