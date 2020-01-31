package ${configs.packageName}.data.common.pagination.paged

import androidx.lifecycle.LiveData
import androidx.paging.PagedList
import ${configs.packageName}.data.common.NetworkState

data class PagedListing<T>(
        override val networkState: LiveData<NetworkState>,
        override val initialState: LiveData<NetworkState>,
        override val refresh: () -> Unit,
        override val retry: () -> Unit,

        // the LiveData of paged lists for the UI to observe
        val list: LiveData<PagedList<T>>
) : Listing<T>