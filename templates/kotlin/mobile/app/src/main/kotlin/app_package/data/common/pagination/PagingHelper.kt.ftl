package ${configs.packageName}.data.common.pagination

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations
import androidx.paging.LivePagedListBuilder
import androidx.paging.PagedList
import ${configs.packageName}.data.common.pagination.paged.ListListing
import ${configs.packageName}.data.common.pagination.paged.Listing
import ${configs.packageName}.data.common.pagination.paged.PagedDataSourceFactory
import ${configs.packageName}.data.common.pagination.paged.PagedListing
import ${configs.packageName}.utils.helper.AppExecutors

class PagingHelper {

    companion object {

        fun <PaginatedType, T> getPagedPreference(usePaging: Boolean, factory: PagedDataSourceFactory<PaginatedType, T>, appExecutors: AppExecutors): Listing<T> {
            return if (usePaging) {
                val config = PagedList.Config.Builder()
                        .setEnablePlaceholders(false)
                        .setInitialLoadSizeHint(factory.offset)
                        .setPageSize(factory.offset)
                        .build()

                val livePagedList = LivePagedListBuilder(factory, config)
                        .setInitialLoadKey(factory.initialPage())
                        .setBoundaryCallback(object : PagedList.BoundaryCallback<T>() {
                            override fun onZeroItemsLoaded() {
                                super.onZeroItemsLoaded()
                                // Handle empty initial load here
                            }
                            override fun onItemAtEndLoaded(itemAtEnd: T) {
                                super.onItemAtEndLoaded(itemAtEnd)
                                // Here you can listen to last item on list
                            }
                            override fun onItemAtFrontLoaded(itemAtFront: T) {
                                super.onItemAtFrontLoaded(itemAtFront)
                                // Here you can listen to first item on list
                            }
                        })
                        .setFetchExecutor(appExecutors.getMainThread())
                        .build()

                PagedListing<T>(
                        list = livePagedList,
                        networkState = Transformations.switchMap(factory.source) { it.network },
                        retry = { factory.source.value?.retryAllFailed() },
                        refresh = { factory.source.value?.invalidate() },
                        initialState = Transformations.switchMap(factory.source) { it.initial })
            } else {
                factory.create()
                ListListing(
                        list = Transformations.switchMap(factory.source) { it.networkData } as MutableLiveData<MutableList<T>>,
                        networkState = Transformations.switchMap(factory.source) { it.network },
                        retry = { factory.source.value?.retryAllFailed() },
                        refresh = { factory.source.value?.listListingInvalidate() },
                        initialState = Transformations.switchMap(factory.source) { it.initial },
                        loadNext = { factory.source.value?.loadNext() })
            }
        }
    }

}