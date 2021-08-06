package ${configs.packageName}.di.module

import dagger.Module
import dagger.android.ContributesAndroidInjector
import ${configs.packageName}.ui.dialog.MessageDialog
import ${configs.packageName}.ui.dialog.LoadingDialog

@Module
abstract class DialogBuilderModule {

    @ContributesAndroidInjector
    abstract fun contributesLoadingDialog(): LoadingDialog

    @ContributesAndroidInjector
    abstract fun contributesMessageDialog(): MessageDialog

}