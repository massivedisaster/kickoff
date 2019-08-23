package ${configs.packageName}.utils.manager

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.TaskStackBuilder
import androidx.fragment.app.Fragment
import ${configs.packageName}.ui.base.BaseActivity
import ${configs.packageName}.ui.splash.SplashActivity
import ${configs.packageName}.ui.widgets.afm.FragmentCall
import javax.inject.Inject
import kotlin.reflect.KClass

class CallManager @Inject constructor() {

    fun splash(context: Context?): Intent {
        val intent = Intent(context, SplashActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        return intent
    }

    private fun replaceFragment(activity: BaseActivity<*, *>, fragmentClass: KClass<out Fragment>, bundle: Bundle) {
        FragmentCall.init(activity, fragmentClass).setTransitionType(FragmentCall.TransitionType.REPLACE).setBundle(bundle).build()
    }

    private fun addFragment(activity: BaseActivity<*, *>, fragmentClass: KClass<out Fragment>, bundle: Bundle) {
        FragmentCall.init(activity, fragmentClass).setTransitionType(FragmentCall.TransitionType.ADD).setBundle(bundle).build()
    }

    fun openSettings(): Intent {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        return intent
    }

}