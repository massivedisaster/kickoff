package ${configs.packageName}.ui.widgets.itemdecorators

import androidx.recyclerview.widget.RecyclerView

/**
 * applies decorators to recyclerviews that enable animations properly.
 *
 * &nbsp;
 *
 * ### WARNING:
 * do not re add these decorators and also do not remove and add again these decorators.
 *
 * these decorators change your recycler view margins to adjust it to your spacing needs
 * if you reuse these decorators on the same view several times it will
 * mess with your recycler view margins.
 *
 * Therefore set these decorators only once per view creation
 * you can add/check if the recycler already has the decorators by using
 *
 * &nbsp;
 *
 * if(itemDecorationCount <= 0)
 */
class SpaceItemDecorations {
    companion object {
        fun sectionedGridSpaceItemDecoration(recycler: RecyclerView, verticalSpacing : Float, horizontalSpacing : Float)
                = SectionedGridSpaceItemDecoration(recycler, horizontalSpacing, verticalSpacing)

        fun sectionedGridSpaceItemDecoration(recycler: RecyclerView, verticalSpacing : Float, horizontalSpacing : Float, dismissViewTypes : ArrayList<Int>, firstRowTopPadding : Float = 0F)
                = SectionedGridSpaceItemDecoration(recycler, horizontalSpacing, verticalSpacing, dismissViewTypes, firstRowTopPadding)

        fun sectionedVerticalSpaceItemDecoration(recycler: RecyclerView, horizontalSpacing : Float) = SectionedVerticalSpaceItemDecoration(recycler, horizontalSpacing)

        fun sectionedVerticalSpaceItemDecoration(recycler: RecyclerView, horizontalSpacing : Float, dismissViewTypes : ArrayList<Int>, firstRowTopPadding : Float = 0F) = SectionedVerticalSpaceItemDecoration(recycler, horizontalSpacing, dismissViewTypes, firstRowTopPadding)

        fun sectionedHorizontalSpaceItemDecoration(recycler: RecyclerView, horizontalSpacing : Float) = SectionedVerticalSpaceItemDecoration(recycler, horizontalSpacing)
    }
}