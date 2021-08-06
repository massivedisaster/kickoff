package ${configs.packageName}.di.module

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import dagger.Binds
import dagger.Module
import dagger.multibindings.IntoMap
import ${configs.packageName}.di.annotations.ViewModelKey
import ${configs.packageName}.di.factory.ViewModelFactory
import ${configs.packageName}.ui.screens.splash.SplashViewModel

@Module(includes = [RepositoryModule::class])
abstract class ViewModelModule {

    @Binds
    abstract fun bindsViewModelFactory(viewModelFactory: ViewModelFactory): ViewModelProvider.Factory

    @Binds
    @IntoMap
    @ViewModelKey(SplashViewModel::class)
    abstract fun bindsSplashViewModel(splashViewModel: SplashViewModel): ViewModel

}