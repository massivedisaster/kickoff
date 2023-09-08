package ${configs.packageName}.di.module

import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@InstallIn(SingletonComponent::class)
@Module
abstract class RepositoryModule {

    /*@Binds
    abstract fun bindsDashboardRepository(dashboardRepositoryImpl: DashboardRepositoryImpl): DashboardRepository*/

}