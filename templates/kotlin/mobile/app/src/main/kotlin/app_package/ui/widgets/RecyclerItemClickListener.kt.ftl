package ${configs.packageName}.ui.widgets

import android.content.Context
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import androidx.recyclerview.widget.RecyclerView

/**
* Listener to handle recycler view clicks
*/
class RecyclerItemClickListener(context: Context, private val listener: (View, Int) -> Unit) : RecyclerView.OnItemTouchListener {

    private val gestureDetector: GestureDetector = GestureDetector(context, object : GestureDetector.SimpleOnGestureListener() {
        override fun onSingleTapUp(e: MotionEvent): Boolean {
            return true
        }
    })

    /**
    * {@inheritDoc}
    */
    override fun onInterceptTouchEvent(view: RecyclerView, e: MotionEvent): Boolean {
        val childView = view.findChildViewUnder(e.x, e.y)
        if (childView != null && gestureDetector.onTouchEvent(e)) {
            listener(childView, view.getChildAdapterPosition(childView))
        }
        return false
    }

    /**
    * {@inheritDoc}
    */
    override fun onTouchEvent(view: RecyclerView, motionEvent: MotionEvent) {}

    /**
    * {@inheritDoc}
    */
    override fun onRequestDisallowInterceptTouchEvent(b: Boolean) {}

}
