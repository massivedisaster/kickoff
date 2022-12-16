package ${configs.packageName}.ui.base

import android.os.Bundle
import android.view.*
import androidx.annotation.LayoutRes
import androidx.annotation.StringRes
import androidx.core.view.WindowInsetsCompat
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.InsetsListener
import ${configs.packageName}.utils.helper.extensions.viewModels
import ${configs.packageName}.utils.manager.NetworkManager
import kotlin.reflect.KClass


abstract class BaseFragment<T : ViewDataBinding, VM : ViewModel> : Fragment() {

    //makes fragment lazy
    open var useLazyLoading = false
    protected val debouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    protected val dataBinding: T by lazy {
        DataBindingUtil.inflate<T>(LayoutInflater.from(context), layoutToInflate(), null, false)
    }

    protected val viewModel: VM by when (getViewModelClass().second) {
        is BaseFragment<*, *> -> viewModels(getViewModelClass().first)
        is BaseActivity<*, *> -> viewModels(getViewModelClass().first) { baseActivity!! }
        else -> throw Exception("ViewModel holder must be of type BaseFragment or BaseActivity")
    }

    protected val insetsCollapseListener: InsetsListener by lazy { InsetsListener() }
    protected var hasConnection = false

    private val containerView: View? by lazy {
        getViewContainer()
    }
    open fun getViewContainer(): View? = null
    open fun insetRules(insets: WindowInsetsCompat) { }

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass() : Pair<KClass<VM>, *>

    abstract fun doOnCreated()

    open fun getArguments(arguments: Bundle) {}

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?) : View? {
        initDataBinding()
        return dataBinding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        arguments?.let {
            getArguments(it)
        }

        val menuResId = menuResourceId
        setHasOptionsMenu(menuResId > -1)

        NetworkManager(context).observe(viewLifecycleOwner) { isConnected ->
            isConnected?.let {
                hasConnection = it
            }
        }

        containerView?.let {
            insetsCollapseListener.listenStatusHeightChange(it) { _, insets -> insetRules(insets) }
        }

        if(useLazyLoading.not()) {
            doOnCreated()
        } else if(isVisibleFirstTime.not()) {
            //else will run when visible to user (visible to user might not run because view might be null, there. so we run here in case is not the first time)
            doOnCreated()
        }
    }

    private var isVisibleFirstTime = true
    override fun onResume() {
        super.onResume()
        if(useLazyLoading && isVisibleFirstTime && view != null) {
            doOnCreated()
        }
        isVisibleFirstTime = false
        // load you data
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

}