package ${configs.packageName}.ui.screens.splash

import android.os.Handler
<#if configs.hasOneSignal!true>
import com.onesignal.OneSignal
</#if>
import ${configs.packageName}.R
import ${configs.packageName}.databinding.ActivitySplashBinding
import ${configs.packageName}.ui.base.BaseActivity
import ${configs.packageName}.utils.manager.CallManager
import ${configs.packageName}.utils.manager.PreferencesManager
import javax.inject.Inject

/**
 * Activity to apply the splash screen.
 */
class SplashActivity : BaseActivity<ActivitySplashBinding, SplashViewModel>() {

    companion object {
        private const val SPLASH_TIME_OUT: Long = 2000
    }

    @Inject
    lateinit var callManager: CallManager

    @Inject
    lateinit var preferencesManager: PreferencesManager

    private var handler: Handler? = null
    private var startTime: Long = 0

    /**
     * Gets the timeout for the splash finishes.
     *
     * @return the timeout.
     */
    private val timeout: Long
        get() {
            val diff = System.currentTimeMillis() - startTime
            return if (diff > SPLASH_TIME_OUT) 0 else SPLASH_TIME_OUT - diff
        }

    override fun layoutToInflate() = R.layout.activity_splash

    override fun getViewModelClass() = SplashViewModel::class.java

    override fun doOnCreated() { }

    public override fun onStart() {
        super.onStart()
        handler = Handler()
    }

    public override fun onResume() {
        super.onResume()
        <#if configs.hasOneSignal!true>
        OneSignal.idsAvailable { userId, _ -> preferencesManager.write(PreferencesManager.PUSH_ID, userId) }
        </#if>

        startTime = System.currentTimeMillis()
        if (handler == null) return

        handler!!.postDelayed({
            //startActivity(callManager.home(this))
            //finishAffinity()
        }, timeout)
    }

    public override fun onPause() {
        super.onPause()
        handler!!.removeCallbacksAndMessages(null)
    }

}
