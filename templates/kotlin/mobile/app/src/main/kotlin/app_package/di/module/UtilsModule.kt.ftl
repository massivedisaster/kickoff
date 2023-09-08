package ${configs.packageName}.di.module

import android.app.Application
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import ${configs.packageName}.utils.helper.GPSHelper
import ${configs.packageName}.utils.helper.PermissionHelper
import ${configs.packageName}.utils.manager.CallManager
import ${configs.packageName}.utils.manager.DialogManager
import ${configs.packageName}.utils.manager.PreferencesManager
import javax.inject.Singleton

@InstallIn(SingletonComponent::class)
@Module
class UtilsModule {

    @Singleton
    @Provides
    fun providesIntentManager() = CallManager()

    @Singleton
    @Provides
    fun providesDialogManager() = DialogManager()

    @Singleton
    @Provides
    fun providesPreferencesManager(application: Application) = PreferencesManager(application)

    @Singleton
    @Provides
    fun providesPermissionHelper() = PermissionHelper()

    @Singleton
    @Provides
    fun providesGPSHelper(application: Application, permissionHelper: PermissionHelper) = GPSHelper(application, permissionHelper)

}