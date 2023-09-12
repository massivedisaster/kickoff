package ${configs.packageName}.utils.helper.extensions.view

import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

/**
 * notify visible items of changes, it is assumed that the not visible items do not need to be refreshed since
 * they will recreated upon scrolling
 *
 * in very rare ocasions we might want to notify the recyler of item changes without passing a new data set
 *
 * example: cards in list can be premium, have a premium icon showing and can only be accessed when user is premium
 * cards can be premium or not
 * user can be premium or not
 * when user premium state changes we should refresh the recyclerviewadapter state, but the data can still be the same
 * because each card data has the object the user is trying to access but not the user object or premium state
 * we can use this function to refresh the recyclerviewadapter data upon user premium state changes, for example, to show/hide
 * the premium icon or allow/disallow user access, etc
 */
fun RecyclerView.Adapter<RecyclerView.ViewHolder>.notifyVisibleItemsChange(recycler: RecyclerView) {

    when(recycler.layoutManager) {
        is LinearLayoutManager -> {
            val manager = recycler.layoutManager as LinearLayoutManager
            val posStart = manager.findFirstVisibleItemPosition()
            val count =  manager.findLastVisibleItemPosition() - posStart + 1
            notifyItemRangeChanged(posStart, count)
        }
        is GridLayoutManager -> {
            val manager = recycler.layoutManager as GridLayoutManager
            val posStart = manager.findFirstVisibleItemPosition()
            val count = manager.findLastVisibleItemPosition() - posStart + 1
            notifyItemRangeChanged(posStart, count)
        }
        else -> throw TypeCastException("The layout manager used by this recycler view is not supported")
    }
}