package ${configs.packageName}.di.module

import dagger.Module
import dagger.android.ContributesAndroidInjector
import ${configs.packageName}.ui.splash.SplashActivity

@Module
abstract class ActivityBuilderModule {

    @ContributesAndroidInjector
    abstract fun contributesSplashActivity(): SplashActivity

}