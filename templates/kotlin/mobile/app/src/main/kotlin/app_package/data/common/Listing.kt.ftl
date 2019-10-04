package ${configs.packageName}.data.common

import androidx.lifecycle.LiveData
import androidx.paging.PagedList

data class Listing<T>(
        // the LiveData of paged lists for the UI to observe
        val pagedList: LiveData<PagedList<T>>,
        // represents the network request status to show to the user
        val networkState: LiveData<NetworkState>,
        // represents the refresh status to show to the user. Separate from network, this
        // value is importantly only when refresh is requested.
        val initialState: LiveData<NetworkState>,
        // refreshes the whole data and fetches it from scratch.
        val refresh: () -> Unit,
        // retries any failed requests.
        val retry: () -> Unit)