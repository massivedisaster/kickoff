package ${configs.packageName}.ui.widgets.popups

import android.content.Context
import android.graphics.Rect
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.PopupWindow
import androidx.annotation.DrawableRes

open class RelativeCardPopup(private val ctx: Context, width: Int, height: Int = ViewGroup.LayoutParams.WRAP_CONTENT) : PopupWindow(width, height) {

    enum class AlignMode {
        DEFAULT, CENTER_FIX, AUTO_OFFSET
    }

    private val container = LinearLayout(ctx)
    private val anchorImage = ImageView(ctx)
    private val content = FrameLayout(ctx)
    var marginScreen = 0
    var alignMode = AlignMode.DEFAULT

    init {
        container.orientation = LinearLayout.VERTICAL
        setBackgroundDrawable(ColorDrawable())
        isOutsideTouchable = true
        isFocusable = true
    }

    override fun setContentView(contentView: View?) {
        contentView?.let {
            container.removeAllViews()
            container.addView(anchorImage, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            container.addView(content, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
            content.addView(contentView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
            super.setContentView(container)
        }
    }

    override fun setBackgroundDrawable(background: Drawable?) {
        content.background = background
        super.setBackgroundDrawable(ColorDrawable())
    }

    fun showAsPointer(anchor: View) {
        showAsPointer(anchor, 0, 0)
    }

    fun showAsPointer(anchor: View, x: Int , y: Int) {
        // get location and size
        var xOff = x
        var yOff = y
        val displayFrame = Rect()
        anchor.getWindowVisibleDisplayFrame(displayFrame)
        val displayFrameWidth = displayFrame.right - displayFrame.left
        val loc = IntArray(2)
        anchor.getLocationInWindow(loc)
        if (alignMode == AlignMode.AUTO_OFFSET) {
            // compute center offset rate
            val offCenterRate = (displayFrame.centerX() - loc[0]) / displayFrameWidth.toFloat()
            xOff = ((anchor.width - displayFrameWidth) / 2 + offCenterRate * displayFrameWidth / 2).toInt()
        } else if (alignMode == AlignMode.CENTER_FIX) {
            xOff = (anchor.width - displayFrameWidth) / 2
        }
        val left = loc[0] + xOff
        val right = left + displayFrameWidth
        // reset x offset to display the window fully in the screen
        if (right > displayFrameWidth - marginScreen) {
            xOff = displayFrameWidth - marginScreen - displayFrameWidth - loc[0]
        }
        if (left < displayFrame.left + marginScreen) {
            xOff = displayFrame.left + marginScreen - loc[0]
        }
        computePointerLocation(anchor, xOff)
        super.showAsDropDown(anchor, xOff, yOff)

        update()
    }

    fun setPointerImageRes(@DrawableRes res: Int) {
        anchorImage.setImageResource(res)
    }

    private fun computePointerLocation(anchor: View, xOff: Int) {
        val aw = anchor.width
        val dw = anchorImage.drawable.intrinsicWidth
        anchorImage.setPadding((aw - dw) / 2 - xOff, 10, 0, 0)
    }

}