package ${configs.packageName}.ui.widgets.itemdecorators

import android.graphics.Rect
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class SectionedVerticalSpaceItemDecoration(recycler: RecyclerView,
                                           private val horizontalSpacing: Float,
                                           private val dismissViewTypes: ArrayList<Int> = arrayListOf(),
                                           private val firstRowTopPadding: Float = 0F) : RecyclerView.ItemDecoration() {

    init {
        val marginLayoutParams = recycler.layoutParams as ViewGroup.MarginLayoutParams
        marginLayoutParams.setMargins(marginLayoutParams.marginStart,
                marginLayoutParams.topMargin - (horizontalSpacing.toInt() / 2),
                marginLayoutParams.marginEnd,
                marginLayoutParams.bottomMargin - (horizontalSpacing.toInt() / 2))
        recycler.layoutParams = marginLayoutParams
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        val adapter = parent.adapter!!
        val itemPosition = parent.getChildAdapterPosition(view)

        // If position not found
        if (itemPosition == RecyclerView.NO_POSITION) {
            return
        }

        val itemType = adapter.getItemViewType(itemPosition)


        if (!dismissViewTypes.contains(itemType)) {
            outRect.top = horizontalSpacing.toInt() / 2
            outRect.bottom = horizontalSpacing.toInt() / 2
        } else {

            val itemCount = parent.layoutManager?.itemCount ?: 0

            //if is first row put padding top
            if (itemPosition == 0) {
                outRect.top = (horizontalSpacing.toInt() / 2) + firstRowTopPadding.toInt()
            }

            //if is last row put padding bottom
            val lastIndex = itemCount - 1
            if (itemPosition == lastIndex) {
                outRect.bottom = horizontalSpacing.toInt() / 2
            }

        }

    }


}
