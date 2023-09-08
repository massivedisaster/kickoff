package ${configs.packageName}.ui.screens.splash

import android.os.Handler
import android.os.Looper
import dagger.hilt.android.AndroidEntryPoint
<#if configs.hasOneSignal!true>
import com.onesignal.OSSubscriptionObserver
import com.onesignal.OSSubscriptionStateChanges
import com.onesignal.OneSignal
</#if>
import ${configs.packageName}.R
import ${configs.packageName}.databinding.ActivitySplashBinding
import ${configs.packageName}.ui.base.BaseActivity
import ${configs.packageName}.utils.authentication.AccountUtils
import ${configs.packageName}.utils.manager.CallManager
import ${configs.packageName}.utils.manager.PreferencesManager
import javax.inject.Inject

/**
 * Activity to apply the splash screen.
 */
@AndroidEntryPoint
class SplashActivity : BaseActivity<ActivitySplashBinding, SplashViewModel>()<#if configs.hasOneSignal!true>, OSSubscriptionObserver</#if> {

    companion object {
        private const val SPLASH_TIME_OUT: Long = 2000
    }

    @Inject lateinit var accountUtils: AccountUtils
    @Inject lateinit var callManager: CallManager
    @Inject lateinit var preferencesManager: PreferencesManager

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

    override fun getViewModelClass() = SplashViewModel::class

    override fun doOnCreated() { }

    public override fun onStart() {
        super.onStart()
        handler = Handler(Looper.getMainLooper())
    }

    public override fun onResume() {
        super.onResume()
        <#if configs.hasOneSignal!true>
        OneSignal.addSubscriptionObserver(this)
        </#if>

        if (!preferencesManager.read(PreferencesManager.PUSH_ID,"").isNullOrEmpty()) {
            init()
        }

    }

    private fun init() {
        startTime = System.currentTimeMillis()
        if (handler == null) return

        handler!!.postDelayed({
            //startActivity(callManager.home(this))
            //finishAffinity()
        }, timeout)
    }

<#if configs.hasOneSignal!true>
    override fun onOSSubscriptionChanged(stateChanges: OSSubscriptionStateChanges) {
        if (!stateChanges.from.isSubscribed && stateChanges.to.isSubscribed) {
            // get player ID
            stateChanges.to.userId
            preferencesManager.write(PreferencesManager.PUSH_ID, stateChanges.to.userId)
            init()
        }
    }
</#if>

    public override fun onPause() {
        super.onPause()
        handler!!.removeCallbacksAndMessages(null)
    }

}
