package ${configs.packageName}.ui.base

import android.app.Activity
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.View.*
import android.view.Window
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import androidx.annotation.DrawableRes
import androidx.annotation.IdRes
import androidx.annotation.LayoutRes
import androidx.annotation.StringRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import dagger.android.AndroidInjection
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasAndroidInjector
import ${configs.packageName}.R
import ${configs.packageName}.data.common.CallResult
import ${configs.packageName}.data.common.ServerErrors
import ${configs.packageName}.ui.animation.AnimationType
import ${configs.packageName}.ui.animation.TransactionAnimation
import ${configs.packageName}.ui.dialog.LoadingDialog
import ${configs.packageName}.ui.dialog.MessageDialog
import ${configs.packageName}.ui.widgets.afm.OnBackPressedListener
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.extensions.hideKeyboard
import ${configs.packageName}.utils.helper.extensions.setSystemBarTransparent
import ${configs.packageName}.utils.manager.NetworkManager
import javax.inject.Inject

abstract class BaseActivity<T : ViewDataBinding, VM : ViewModel> : AppCompatActivity(), HasAndroidInjector, TransactionAnimation {

    companion object {
        @JvmField
        val ACTIVITY_MANAGER_FRAGMENT = "ACTIVITY_MANAGER_FRAGMENT"
        @JvmField
        val ACTIVITY_MANAGER_FRAGMENT_TAG = "ACTIVITY_MANAGER_FRAGMENT_TAG"
        @JvmField
        val ACTIVITY_MANAGER_FRAGMENT_SHARED_ELEMENTS = "ACTIVITY_MANAGER_FRAGMENT_SHARED_ELEMENTS"

        const val DEFAULT_CONTAINER_ID = 0
    }

    @Inject
    lateinit var androidInjector: DispatchingAndroidInjector<Any>

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    //to draw behind potential transparent status bar
    open var drawBehindStatusBar = false

    //to draw behind potential transparent bottom navigation bar
    open var drawBehindBottomNavigation = false

    open var setFullScreen = false

    open var adjustNothing = false

    private var loadingDialog: LoadingDialog? = null
    private var messageDialog: MessageDialog? = null
    protected var hasConnection = false

    protected val dataBinding: T by lazy {
        DataBindingUtil.setContentView<T>(this, layoutToInflate())
    }

    protected val viewModel: VM by lazy {
        ViewModelProvider(this, viewModelFactory).get(getViewModelClass())
    }

    protected val debouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass(): Class<VM>

    abstract fun doOnCreated()

    @IdRes
    open fun containerId() = DEFAULT_CONTAINER_ID

    override fun androidInjector() = androidInjector

    open fun getArguments(arguments: Bundle) {}

    override fun onCreate(savedInstanceState: Bundle?) {
        requestWindowFeature(Window.FEATURE_ACTIVITY_TRANSITIONS)
        requestWindowFeature(Window.FEATURE_CONTENT_TRANSITIONS)

        if (drawBehindStatusBar && drawBehindBottomNavigation) {
           window.decorView.systemUiVisibility = SYSTEM_UI_FLAG_LAYOUT_STABLE or SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        } else {
           if (drawBehindStatusBar) {
               window.decorView.systemUiVisibility = SYSTEM_UI_FLAG_LAYOUT_STABLE or SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
           }
           if (drawBehindBottomNavigation) {
               window.decorView.systemUiVisibility = SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
           }
        }

        AndroidInjection.inject(this)
        if (intent.extras != null) {
            getArguments(intent.extras!!)
        }

        super.onCreate(savedInstanceState)
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
        if(adjustNothing) {
           window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING)
        }
        initDataBinding()

        if (supportFragmentManager.fragments.isEmpty() && supportFragmentManager.backStackEntryCount == 0) {
            if (intent.hasExtra(ACTIVITY_MANAGER_FRAGMENT)) {
                performInitialTransaction(getFragment(intent.getStringExtra(ACTIVITY_MANAGER_FRAGMENT)!!), getFragmentTag())
            } else if (getDefaultFragment() != null) {
                performInitialTransaction(getFragment(getDefaultFragment()!!.canonicalName!!), null)
            }
        }

        NetworkManager(this).observe(this) { isConnected ->
            isConnected?.let {
                hasConnection = it
            }
        }

        doOnCreated()
        //setSystemBarTransparent()
    }

    private fun hideSystemUI() {
        // Enables regular immersive mode.
        // For "lean back" mode, remove SYSTEM_UI_FLAG_IMMERSIVE.
        // Or for "sticky immersive," replace it with SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_IMMERSIVE
                // Set the content to appear under the system bars so that the
                // content doesn't resize when the system bars hide and show.
                or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                // Hide the nav bar and status bar
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_FULLSCREEN)
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus && setFullScreen) hideSystemUI()
    }

    protected open fun getDefaultFragment(): Class<out Fragment>? {
        return null
    }

    override fun onDestroy() {
        dataBinding.unbind()
        super.onDestroy()
    }

    protected open fun loadInitialFragment() { }

    override fun onStop() {
        val inputManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputManager.hideSoftInputFromWindow(currentFocus?.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

        super.onStop()
    }

    private fun initDataBinding() {
        dataBinding.lifecycleOwner = this
    }

    /**
     * Perform a transaction of a fragment.
     *
     * @param fragment the fragment to be applied.
     * @param tag      the tag to be applied.
     */
    private fun performInitialTransaction(fragment: Fragment?, tag: String?) {
         if (fragment != null) {
            val fragmentTransaction = supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(containerId(), fragment, tag)
            fragmentTransaction.commitNow()
         }
    }

    override val animationEnter = android.R.anim.fade_in
    override val animationExit = android.R.anim.fade_out
    override val animationPopEnter = android.R.anim.fade_in
    override val animationPopExit = android.R.anim.fade_out

    private fun getFragmentTag() = intent.getStringExtra(ACTIVITY_MANAGER_FRAGMENT_TAG)

    /**
     * Get a new instance of the Fragment by name.
     * @param clazz the canonical Fragment name.
     * *
     * @return the instance of the Fragment.
     */
    private fun getFragment(clazz: String): Fragment? {
        try {
            val fragment = Class.forName(clazz).newInstance() as Fragment
            if (intent.extras != null) {
                fragment.arguments = intent.extras
            }

            return fragment
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    override fun onBackPressed() {
       if (!canBackPress()) {
           super.onBackPressed()
       }
    }

    /**
     * Checks if the active fragment wants to consume the back press.
     * @return false if the fragment wants the activity to call super.onBackPressed, otherwise nothing will happen.
     */
    private fun canBackPress(): Boolean {
       val activeFragment = getActiveFragment()
       return activeFragment != null
           && activeFragment is OnBackPressedListener
           && (activeFragment as OnBackPressedListener).onBackPressed()
    }

    /**
     * Gets the active fragment.
     * @return the active fragment.
     */
    fun getActiveFragment() = supportFragmentManager.findFragmentById(containerId())

    /**
     * Defines a transition animation to the given activity
     *
     * @param activity      The activity for animation.
     * @param animationType The type of the animation.
     */
    fun defineActivityTransitionAnimation(activity: Activity, @AnimationType animationType: Int) {
        /*when (animationType) {
            Animations.LEFT -> activity.overridePendingTransition(R.anim.fragment_left_in, R.anim.fragment_right_out)
            Animations.RIGHT -> activity.overridePendingTransition(R.anim.fragment_right_in, R.anim.fragment_left_out)
            Animations.UP -> activity.overridePendingTransition(R.anim.fragment_up_in, R.anim.fragment_down_out)
            Animations.DOWN -> activity.overridePendingTransition(R.anim.fragment_down_in, R.anim.fragment_up_out)
            Animations.LEFT_IN -> activity.overridePendingTransition(R.anim.fragment_left_in, R.anim.fragment_static)
            Animations.RIGHT_IN -> activity.overridePendingTransition(R.anim.fragment_right_in, R.anim.fragment_static)
            Animations.UP_IN -> activity.overridePendingTransition(R.anim.fragment_up_in, R.anim.fragment_static)
            Animations.DOWN_IN -> activity.overridePendingTransition(R.anim.fragment_down_in, R.anim.fragment_static)
            Animations.LEFT_OUT -> activity.overridePendingTransition(R.anim.fragment_static, R.anim.fragment_left_out)
            Animations.RIGHT_OUT -> activity.overridePendingTransition(R.anim.fragment_static, R.anim.fragment_right_out)
            Animations.UP_OUT -> activity.overridePendingTransition(R.anim.fragment_static, R.anim.fragment_up_out)
            Animations.DOWN_OUT -> activity.overridePendingTransition(R.anim.fragment_static, R.anim.fragment_down_out)
        }*/
    }

    open fun showLoading() {
        hideKeyboard()
        if (loadingDialog == null) {
            loadingDialog = LoadingDialog()
        }
        if (!loadingDialog!!.isAdded && !loadingDialog!!.isVisible) {
             loadingDialog!!.show(supportFragmentManager, "loading")
             supportFragmentManager.registerFragmentLifecycleCallbacks( object : FragmentManager.FragmentLifecycleCallbacks() {
                override fun onFragmentViewDestroyed(fm: FragmentManager, f: Fragment) {
                    super.onFragmentViewDestroyed(fm, f)
                    if (f is LoadingDialog) {
                        supportFragmentManager.unregisterFragmentLifecycleCallbacks(this)
                        loadingDialog = null
                    }
                }
            }, false)
        }
    }

    open fun hideLoading() {
        if (loadingDialog != null) {
            loadingDialog!!.dismiss()
        }
    }

    open fun handleError(result: CallResult<*>, retry: (() -> Unit)? = null) {
        hideLoading()
        hideMessage()
        val status = result.status
        when (status.error?.serverError) {
            ServerErrors.NO_INTERNET, ServerErrors.TIMEOUT -> showMessage(R.drawable.ic_error, R.string.internet_error, if (retry == null) android.R.string.ok else R.string.btn_retry, retry)
            else -> showMessage(R.drawable.ic_error, R.string.error_generic_body, if (retry == null) android.R.string.ok else R.string.btn_retry, retry)
        }
    }

    open fun showMessage(@DrawableRes icon: Int, @StringRes message: Int, @StringRes okButton: Int, buttonOkExecution: (() -> Unit)? = null, @StringRes cancelButton: Int = -1, cancelExecution: (() -> Unit)? = null, close: Boolean = false) {
        hideKeyboard()
        if (messageDialog == null) {
            messageDialog = MessageDialog.newInstance(message, icon, okButton, buttonOkExecution, cancelButton, cancelExecution, close)
        }
        if (!messageDialog!!.isAdded && !messageDialog!!.isVisible) {
            messageDialog!!.show(supportFragmentManager, "messageDialog")

            supportFragmentManager.registerFragmentLifecycleCallbacks(object : FragmentManager.FragmentLifecycleCallbacks() {
                override fun onFragmentViewDestroyed(fm: FragmentManager, f: Fragment) {
                    super.onFragmentViewDestroyed(fm, f)
                    if (f is MessageDialog) {
                        supportFragmentManager.unregisterFragmentLifecycleCallbacks(this)
                        messageDialog = null
                    }
                }
            }, false)
        }
    }

    open fun hideMessage() {
        if (messageDialog != null) {
            messageDialog!!.dismiss()
        }
    }

}