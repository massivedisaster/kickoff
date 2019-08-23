package ${configs.packageName}.ui.widgets

import android.content.Context
import android.util.AttributeSet
import android.widget.ImageView

class AspectRatioImageView : ImageView {

    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs)
    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(context, attrs, defStyleAttr)

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val width = MeasureSpec.getSize(widthMeasureSpec)
        val height = width * drawable.intrinsicHeight / drawable.intrinsicWidth
        setMeasuredDimension(width, height)
    }

}