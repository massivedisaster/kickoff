package ${configs.packageName}.ui.base

import android.os.Bundle
import android.util.Log
import android.view.*
import androidx.annotation.LayoutRes
import androidx.annotation.StringRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasAndroidInjector
import dagger.android.support.AndroidSupportInjection
import ${configs.packageName}.data.common.CallResult
import ${configs.packageName}.data.common.ServerErrors
import ${configs.packageName}.ui.animation.AnimationType
import ${configs.packageName}.ui.animation.Animations
import ${configs.packageName}.ui.dialog.ErrorDialog
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.extensions.hideKeyboard
import javax.inject.Inject

abstract class BaseFragment<T : ViewDataBinding, VM : ViewModel> : Fragment(), HasAndroidInjector {

    @Inject
    lateinit var androidInjector: DispatchingAndroidInjector<Any>
    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    //makes fragment lazy
    open var useLazyLoading = false

    protected val dataBinding: T by lazy {
        DataBindingUtil.inflate<T>(LayoutInflater.from(context), layoutToInflate(), null, false)
    }

    protected val viewModel: VM by lazy {
        when (getViewModelClass().second) {
            is BaseFragment<*, *> -> ViewModelProvider(this, viewModelFactory).get(getViewModelClass().first)
            is BaseActivity<*, *> -> ViewModelProvider(getViewModelClass().second as FragmentActivity, viewModelFactory).get(getViewModelClass().first)
            else -> throw Exception("ViewModel holder must be of type BaseFragment or BaseActivity")
        }
    }

    protected val clickDebouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    fun viewModelFactoryExists() = ::viewModelFactory.isInitialized

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass() : Pair<Class<VM>, *>

    abstract fun doOnCreated()

    open fun getArguments(arguments: Bundle) {}

    override fun androidInjector() = androidInjector

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?) : View? {
        AndroidSupportInjection.inject(this)
        initDataBinding()
        return dataBinding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (arguments != null) {
            getArguments(arguments!!)
        }

        val menuResId = menuResourceId
        setHasOptionsMenu(menuResId > -1)

        if(useLazyLoading.not()) {
            doOnCreated()
        } else if(isVisibleFirstTime.not()) {
            //else will run when visible to user (visible to user might not run because view might be null, there. so we run here in case is not the first time)
            doOnCreated()
        }
    }

    private var isVisibleFirstTime = true
    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        if (isVisibleToUser) {
            if(useLazyLoading && isVisibleFirstTime && view != null) {
                doOnCreated()
            }
            isVisibleFirstTime = false
            // load you data
        }
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        val menuResId = menuResourceId

        if (menuResId > -1) {
            inflater.inflate(menuResId, menu)
            activity?.invalidateOptionsMenu()
        }
        super.onCreateOptionsMenu(menu, inflater)
    }

    override fun onDestroyView() {
        dataBinding.unbind()
        super.onDestroyView()
    }

    fun getContainerId() = (activity as BaseActivity<*, *>).containerId()

    private fun initDataBinding() {
        dataBinding.lifecycleOwner = this
    }

    /**
     * Get the fragment title.
     *
     * @return [String] The fragment name.
     */
    @get:StringRes
    abstract val fragmentTitle: Int

    /**
     * Get the [ActivityBase] where this fragment is attached.
     *
     * @return [ActivityBase] The Activity where this fragment is attached.
     */
            protected val baseActivity: BaseActivity<*, *>?
            get() = activity as BaseActivity<*, *>

    /**
     * Checks whether fragment can be used or not
     *
     * @return true if the activity is added and visible otherwise false
     */
    val isActive: Boolean
        get() = isAdded && !isDetached && !isRemoving

    /**
     * Get the resource id of the fragment menu.
     *
     * @return int The menu resource id (default: -1).
     */
    internal open var menuResourceId: Int = -1

    /**
     * Defines a transition animation enter for the activity
     *
     * @return animation enter
     */
    @AnimationType
    fun defineActivityAnimationEnter(): Int {
        return Animations.NONE
    }

    /**
     * Defines a transition animation exit for the activity
     *
     * @return animation exit
     */
    @AnimationType
    fun defineActivityAnimationExit(): Int {
        return Animations.NONE
    }

    open fun handleError(result: CallResult<*>) {
        val status = result.status
        when (status.error?.serverError) {
            ServerErrors.NO_INTERNET, ServerErrors.TIMEOUT -> Log.i("BASE", "failed - No Internet")
            else -> Log.i("BASE", "failed - ${r"${status.error?.error?.status}"}")
        }
    }

    private var errorDialog: ErrorDialog? = null
    open fun showError(title: String, message: String, buttonOkText: String, buttonOkExecution: (() -> Unit)? = null) {
        baseActivity?.hideKeyboard()
        if (errorDialog == null) {
            errorDialog = ErrorDialog.newInstance(title, message, buttonOkText, buttonOkExecution)
        }
        if (!errorDialog!!.isAdded && !errorDialog!!.isVisible) {
            errorDialog!!.show(childFragmentManager, "errorDialog")

            childFragmentManager.registerFragmentLifecycleCallbacks( object : FragmentManager.FragmentLifecycleCallbacks() {
                override fun onFragmentViewDestroyed(fm: FragmentManager, f: Fragment) {
                    super.onFragmentViewDestroyed(fm, f)
                    childFragmentManager.unregisterFragmentLifecycleCallbacks(this)
                    errorDialog = null
                }
            }, false)
        }
    }

    open fun hideError() {
        if (errorDialog != null) {
            errorDialog!!.dismiss()
        }
    }
}