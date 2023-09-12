/*
 * Copyright (C) 2017 Dominik Mosberger <https://github.com/mosberger>
 * Copyright (C) 2013 Leszek Mzyk <https://github.com/imbryk>
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

package ${configs.packageName}.utils.helper.extensions.html

import android.graphics.Canvas
import android.graphics.Paint
import android.text.Layout
import android.text.Spanned
import android.text.TextPaint
import android.text.style.LeadingMarginSpan

/**
 * Class to use Numbered Lists in TextViews.
 * The span works the same as [android.text.style.BulletSpan] and all lines of the entry have
 * the same leading margin.
 */
class NumberSpan(textPaint: TextPaint, number: Int) : LeadingMarginSpan {
    private val number = "$number. "
    private val textWidth = textPaint.measureText(this.number).toInt()

    override fun getLeadingMargin(first: Boolean) = textWidth

    override fun drawLeadingMargin(c: Canvas, p: Paint, x: Int, dir: Int, top: Int, baseline: Int, bottom: Int, text: CharSequence, start: Int, end: Int, first: Boolean, l: Layout) {
        if (text is Spanned) {
            val spanStart = text.getSpanStart(this)
            if (spanStart == start) {
                c.drawText(number, x.toFloat(), baseline.toFloat(), p)
            }
        }
    }
}