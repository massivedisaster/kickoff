package ${configs.packageName}.utils.helper.extensions.android

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout

fun SwipeRefreshLayout.stopRefreshing() {
    if (isRefreshing) {
        isRefreshing = false
    }
}