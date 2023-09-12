package ${configs.packageName}.utils.helper.extensions.view

import android.view.ViewGroup
import android.widget.HorizontalScrollView

fun HorizontalScrollView.smoothScrollIntoFocus(position: Int, childView: ViewGroup, screenWidth : Int) {
    val view = childView.getChildAt(position)
    val scrollX = view.left - screenWidth / 2 + view.width / 2
    this.smoothScrollTo(scrollX, 0)
}