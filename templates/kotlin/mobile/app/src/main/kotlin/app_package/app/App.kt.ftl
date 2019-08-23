package ${configs.packageName}.app

import android.app.Application
import android.content.Context
import ${configs.packageName}.di.component.DaggerAppComponent
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasAndroidInjector
import javax.inject.Inject
<#if configs.hasOnesignal!true>
import com.onesignal.OneSignal
</#if>

/**
 * Base class fot the application.
 * You need to add this class to your manifest file.
 */
open class App @Inject constructor() : Application(), HasAndroidInjector {

    @Inject
    lateinit var androidInjector: DispatchingAndroidInjector<Any>

    override fun androidInjector() = androidInjector

    override fun onCreate() {
        super.onCreate()
        <#if configs.hasOnesignal!true>

        OneSignal.startInit(this).init()
		</#if>
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        DaggerAppComponent.builder().application(this).build().inject(this)
    }

}