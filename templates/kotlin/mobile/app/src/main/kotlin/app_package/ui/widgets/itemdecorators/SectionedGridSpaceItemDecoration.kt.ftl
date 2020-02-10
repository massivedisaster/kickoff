package ${configs.packageName}.ui.widgets.itemdecorators

import android.graphics.Rect
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView

class SectionedGridSpaceItemDecoration(recycler: RecyclerView,
                                       private val horizontalSpacing: Float,
                                       private val verticalSpacing: Float,
                                       private val dismissViewTypes: ArrayList<Int> = arrayListOf(),
                                       private val hotFix_firstRowTopPadding: Float = 0F
//                                       , private val sectionItemCount: (itemType: Int) -> Int,
//                                       private val sectionFirstItemIndex: (itemType: Int) -> Int,
//                                       private val sectionLastItemIndex: (itemType: Int) -> Int
) : RecyclerView.ItemDecoration() {

    private var spanCount = 0
    init {
        val marginLayoutParams = recycler.layoutParams as ViewGroup.MarginLayoutParams
        marginLayoutParams.setMargins(marginLayoutParams.marginStart - (verticalSpacing.toInt() / 2),
                marginLayoutParams.topMargin - (horizontalSpacing.toInt() / 2),
                marginLayoutParams.marginEnd - (verticalSpacing.toInt() / 2),
                marginLayoutParams.bottomMargin - (horizontalSpacing.toInt() / 2))
        recycler.layoutParams = marginLayoutParams

//            recycler.setPadding(recycler.paddingLeft - (verticalSpacing.toInt() / 2),
//                    recycler.paddingTop - (horizontalSpacing.toInt() / 2),
//                    recycler.paddingRight - (verticalSpacing.toInt() / 2),
//                    recycler.paddingBottom - (horizontalSpacing.toInt() / 2))
        spanCount = (recycler.layoutManager as GridLayoutManager).spanCount
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        val itemPosition = parent.getChildAdapterPosition(view)

        // If position not found
        if (itemPosition == RecyclerView.NO_POSITION) {
            return
        }

        val itemType = parent.adapter?.getItemViewType(itemPosition)

        if ((parent.layoutManager as GridLayoutManager).orientation == RecyclerView.VERTICAL) {
            outRect.left = verticalSpacing.toInt() / 2
            outRect.right = verticalSpacing.toInt() / 2


            if (!dismissViewTypes.contains(itemType)) {
                outRect.top = horizontalSpacing.toInt() / 2
                outRect.bottom = horizontalSpacing.toInt() / 2
            } else {

                val itemCount = (parent.layoutManager as GridLayoutManager).itemCount

                //if is first row put padding top
                if (itemPosition < spanCount) {
                    var firstRowPositions = 0
                    var numberOfSpansInFirstRow = 0
                    for (i in 0..spanCount) {
                        if (i < itemCount && numberOfSpansInFirstRow < spanCount) {
                            numberOfSpansInFirstRow += (parent.layoutManager as GridLayoutManager).spanSizeLookup.getSpanSize(i)
                            firstRowPositions++
                        }
                    }
                    if (itemPosition < firstRowPositions) {
                        outRect.top = (horizontalSpacing.toInt() / 2) + hotFix_firstRowTopPadding.toInt()
                    }
                }

                //if is last row put padding bottom
                val lastIndex = itemCount - 1
                if (itemPosition > lastIndex - spanCount) {
                    var lastRowPositions = 0
                    var numberOfSpansInLasttRow = 0
                    for (i in lastIndex..(lastIndex - spanCount)) {
                        if (i < itemCount && numberOfSpansInLasttRow < spanCount) {
                            numberOfSpansInLasttRow += (parent.layoutManager as GridLayoutManager).spanSizeLookup.getSpanSize(i)
                            lastRowPositions++
                        }
                    }
                    if (itemPosition > lastIndex - lastRowPositions) {
                        outRect.bottom = horizontalSpacing.toInt() / 2
                    }
                }
            }

        }


    }

//    }

//    private fun isLastRowOfType(itemPosition: Int, itemType: Int): Boolean {
//        val itemCountByType = sectionItemCount(itemType)
//        val lastItemIndexByType = sectionLastItemIndex(itemType)
//
//        return if (itemCountByType % 2 == 0) {
//            if (itemCountByType > 1) {
//                itemPosition == lastItemIndexByType || itemPosition == lastItemIndexByType - 1
//            } else {
//                itemPosition == lastItemIndexByType
//            }
//        } else {
//            itemPosition == lastItemIndexByType
//        }
//    }
//
//    private fun isFirstRowOfType(itemPosition: Int, itemType: Int): Boolean {
//        val itemCountByType = sectionItemCount(itemType)
//        val firstItemIndexByType = sectionFirstItemIndex(itemType)
//
//        return if (itemCountByType % 2 == 0) {
//            if (itemCountByType > 1) {
//                itemPosition == firstItemIndexByType || itemPosition == firstItemIndexByType + 1
//            } else {
//                itemPosition == firstItemIndexByType
//            }
//        } else {
//            itemPosition == firstItemIndexByType
//        }
//    }
}