package ${configs.packageName}.data.common.pagination.paged

import androidx.annotation.MainThread
import androidx.lifecycle.MutableLiveData
import androidx.paging.DataSource
import androidx.paging.PageKeyedDataSource
import ${configs.packageName}.data.common.CallResult
import ${configs.packageName}.utils.helper.AppExecutors

abstract class PagedDataSourceFactory<PaginationType, ResultType>
@MainThread constructor(
        val offset: Int,
        private val appExecutors: AppExecutors,
        private val usePaging : Boolean
) : DataSource.Factory<Int, ResultType>() {

    val source = MutableLiveData<PagedDataSourceBoundResource<PaginationType, ResultType>>()

    override fun create(): DataSource<Int, ResultType> {
        val source = object : PagedDataSourceBoundResource<PaginationType, ResultType>(appExecutors, usePaging) {
            override fun createCall(innerPage: Int, pageSize: Int): CallResult<PaginationType> = this@PagedDataSourceFactory.createCall(innerPage, pageSize)

            override fun calculateNextKey(response: PaginationType, nextPage: Int): Int? = this@PagedDataSourceFactory.calculateNextKey(response, nextPage)

            override fun identifyResponseList(response: PaginationType): List<ResultType> = this@PagedDataSourceFactory.identifyResponseList(response)

            override fun initialPage(): Int = this@PagedDataSourceFactory.initialPage()

        }
        this.source.postValue(source)
        if (!usePaging) {
            source.loadInit(PageKeyedDataSource.LoadInitialParams(offset, false), null)
        }
        return source
    }

    @MainThread
    protected abstract fun createCall(innerPage: Int, pageSize: Int): CallResult<PaginationType>

    abstract fun calculateNextKey(response : PaginationType, nextPage : Int) : Int?

    abstract fun identifyResponseList(response: PaginationType): List<ResultType>

    abstract fun initialPage(): Int
}
