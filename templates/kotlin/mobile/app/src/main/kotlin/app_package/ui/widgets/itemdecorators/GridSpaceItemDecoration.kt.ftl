package ${configs.packageName}.ui.widgets.itemdecorators

import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.RecyclerView

class GridSpaceItemDecoration(private var horizontalSpace: Float, private val columns: Int) : RecyclerView.ItemDecoration() {

    private var mNeedLeftSpacing = false

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        val frameWidth = ((parent.width - horizontalSpace * (columns - 1)) / columns)
        val padding = parent.width / columns - frameWidth
        val itemPosition = (view.layoutParams as RecyclerView.LayoutParams).viewAdapterPosition
        if (itemPosition < columns) {
            outRect.top = 0
        } else {
            outRect.top = horizontalSpace.toInt()
        }
        if (itemPosition % columns == 0) {
            outRect.left = 0
            outRect.right = padding.toInt()
            mNeedLeftSpacing = true
        } else if ((itemPosition + 1) % columns == 0) {
            mNeedLeftSpacing = false
            outRect.right = 0
            outRect.left = padding.toInt()
        } else if (mNeedLeftSpacing) {
            mNeedLeftSpacing = false
            outRect.left = (horizontalSpace - padding).toInt()
            if ((itemPosition + 2) % columns == 0) {
                outRect.right = (horizontalSpace - padding).toInt()
            } else {
                outRect.right = (horizontalSpace / 2).toInt()
            }
        } else if ((itemPosition + 2) % columns == 0) {
            mNeedLeftSpacing = false
            outRect.left = (horizontalSpace / 2).toInt()
            outRect.right = (horizontalSpace - padding).toInt()
        } else {
            mNeedLeftSpacing = false
            outRect.left = (horizontalSpace / 2).toInt()
            outRect.right = (horizontalSpace / 2).toInt()
        }
        outRect.bottom = 0
    }

}