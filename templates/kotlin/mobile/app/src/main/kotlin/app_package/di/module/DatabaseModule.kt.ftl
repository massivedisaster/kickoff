package ${configs.packageName}.di.module

import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@InstallIn(SingletonComponent::class)
@Module
class DatabaseModule {

    /*@Singleton
    @Provides
    fun provideDatabase(application: Application): BoxStore = MyObjectBox.builder().androidContext(application).build()*/

}