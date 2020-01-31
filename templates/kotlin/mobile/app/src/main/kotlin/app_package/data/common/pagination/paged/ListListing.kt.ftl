package ${configs.packageName}.data.common.pagination.paged

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import ${configs.packageName}.data.common.NetworkState

data class ListListing<T>(
        override val networkState: LiveData<NetworkState>,
        override val initialState: LiveData<NetworkState>,
        override val refresh: () -> Unit,
        override val retry: () -> Unit,

        // the LiveData of the full list for the UI to observe
        val list: MutableLiveData<MutableList<T>>,
        // retries any failed requests.
        val loadNext: () -> Unit
) : Listing<T>