package ${configs.packageName}.ui.base.adapter

import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

abstract class PaginationScrollListener(var layoutManager: RecyclerView.LayoutManager) : RecyclerView.OnScrollListener() {

    init {
        if(layoutManager !is LinearLayoutManager && layoutManager !is GridLayoutManager) {
            throw UnsupportedOperationException("layout manager must be of type LinearLayoutManager or GridLayoutManager")
        }
    }

    abstract fun isLastPage(): Boolean

    abstract fun isLoading(): Boolean

    override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
        super.onScrolled(recyclerView, dx, dy)

        val visibleItemCount = layoutManager.childCount
        val totalItemCount = layoutManager.itemCount
        var firstVisibleItemPosition = 0
        if(layoutManager is GridLayoutManager) {
            firstVisibleItemPosition = (layoutManager as GridLayoutManager).findFirstVisibleItemPosition()
        }
        if(layoutManager is LinearLayoutManager) {
            firstVisibleItemPosition = (layoutManager as LinearLayoutManager).findFirstVisibleItemPosition()
        }

        if (!isLoading() && !isLastPage()) {
            if (visibleItemCount + firstVisibleItemPosition >= totalItemCount && firstVisibleItemPosition >= 0) {
                loadMoreItems()
            }
        }
    }

    abstract fun loadMoreItems()
}