package ${configs.packageName}.ui.widgets.itemdecorators

import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.RecyclerView

class HorizontalSpaceItemDecoration : RecyclerView.ItemDecoration {

    private val space: Int

    constructor(padding: Float) : super() {
        space = padding.toInt()
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        if (parent.adapter != null && parent.getChildAdapterPosition(view) != parent.adapter!!.itemCount - 1) {
            outRect.right = space
        }
    }
}
