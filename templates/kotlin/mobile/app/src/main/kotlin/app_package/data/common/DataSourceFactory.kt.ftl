package ${configs.packageName}.data.common

import androidx.annotation.MainThread
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.paging.DataSource
import ${configs.packageName}.network.models.ApiResponse
import ${configs.packageName}.utils.helper.AppExecutors

abstract class DataSourceFactory<ItemType, ResultType>
@MainThread constructor(
        private val offset: Int,
        private val appExecutors: AppExecutors
) : DataSource.Factory<Int, ResultType>() {

    val source = MutableLiveData<DataSourceBoundResource<ItemType, ResultType>>()

    override fun create(): DataSource<Int, ResultType> {
        val source = object : DataSourceBoundResource<ItemType, ResultType>(offset, appExecutors) {
            override fun createCall(page: Int, pageSize: Int): LiveData<ApiResponse<MutableList<ItemType>>> = this@DataSourceFactory.createCall(page, pageSize)
        }
        this.source.postValue(source)
        return source
    }

    @MainThread
    protected abstract fun createCall(page: Int, pageSize: Int): LiveData<ApiResponse<MutableList<ItemType>>>

}