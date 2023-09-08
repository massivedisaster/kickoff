package ${configs.packageName}.data.common.pagination

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations
import ${configs.packageName}.data.common.pagination.paged.ListListing
import ${configs.packageName}.data.common.pagination.paged.Listing
import ${configs.packageName}.data.common.pagination.paged.PagedDataSourceFactory

object PagingHelper {

    fun <PaginatedType, Meta, T : Any> getPagedPreference(factory: PagedDataSourceFactory<PaginatedType, Meta, T>): Listing<Meta, T> {
        factory.create()
        return ListListing(
            list = Transformations.switchMap(factory.source) { it.networkData } as MutableLiveData<MutableList<T>>,
            networkState = Transformations.switchMap(factory.source) { it.network },
            retry = { factory.source.value?.retryAllFailed() },
            refresh = { factory.source.value?.listListingInvalidate() },
            initialState = Transformations.switchMap(factory.source) { it.initial },
            loadNext = { factory.source.value?.loadNext() },
            meta = Transformations.switchMap(factory.source) { it.meta } as MutableLiveData<Meta>
        )
    }

}