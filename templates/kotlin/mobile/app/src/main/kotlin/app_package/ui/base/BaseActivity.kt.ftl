package ${configs.packageName}.ui.base

import android.app.Activity
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Window
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import androidx.annotation.IdRes
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import ${configs.packageName}.ui.animation.AnimationType
import ${configs.packageName}.ui.animation.TransactionAnimation
import ${configs.packageName}.ui.widgets.afm.OnBackPressedListener
import dagger.android.AndroidInjection
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasAndroidInjector
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
    open var shouldFullScreenStretch = false

    private var loadingDialog: LoadingDialog? = null
    private var errorDialog: ErrorDialog? = null

    protected val dataBinding: T by lazy {
        DataBindingUtil.setContentView<T>(this, layoutToInflate())
    }

    protected val viewModel: VM by lazy {
        ViewModelProvider(this, viewModelFactory).get(getViewModelClass())
    }

     @LayoutRes
     abstract fun layoutToInflate(): Int

     abstract fun getViewModelClass(): Class<VM>

     abstract fun doOnCreated()

     @IdRes
     open fun containerId() = DEFAULT_CONTAINER_ID

     override fun androidInjector() = androidInjector

     open fun getArguments(arguments: Bundle) {}

     override fun onCreate(savedInstanceState: Bundle?) {
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
             requestWindowFeature(Window.FEATURE_ACTIVITY_TRANSITIONS)
             requestWindowFeature(Window.FEATURE_CONTENT_TRANSITIONS)
         }

         if (shouldFullScreenStretch) {
             window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
         }

         AndroidInjection.inject(this)
         if (intent.extras != null) {
             getArguments(intent.extras!!)
         }

         super.onCreate(savedInstanceState)
         window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
         initDataBinding()
         if (supportFragmentManager.fragments.isEmpty() && supportFragmentManager.backStackEntryCount == 0) {
             if (intent.hasExtra(ACTIVITY_MANAGER_FRAGMENT)) {
                 performInitialTransaction(getFragment(intent.getStringExtra(ACTIVITY_MANAGER_FRAGMENT)), getFragmentTag())
             } else if (getDefaultFragment() != null) {
                 performInitialTransaction(getFragment(getDefaultFragment()!!.canonicalName!!), null)
             }
         }

         doOnCreated()
         setSystemBarTransparent()
     }

     protected open fun getDefaultFragment(): Class<out Fragment>? {
        Log.w("BaseActivity", "No default fragment implemented!")
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

      override val animationEnter: Int
          get() = android.R.anim.fade_in
      override val animationExit: Int
          get() = android.R.anim.fade_out
      override val animationPopEnter: Int
          get() = android.R.anim.fade_in
      override val animationPopExit: Int
          get() = android.R.anim.fade_out

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

}