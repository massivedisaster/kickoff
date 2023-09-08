package ${configs.packageName}.ui.base

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModel
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.InsetsListener
import ${configs.packageName}.utils.helper.extensions.viewModels
import kotlin.reflect.KClass

abstract class BaseDialog<T : ViewDataBinding, VM : ViewModel> : DialogFragment() {

    interface Callback {
        fun onDialogResult(requestCode: Int, resultCode: Int, data: Intent)
    }

    protected val dataBinding: T by lazy {
        DataBindingUtil.inflate<T>(LayoutInflater.from(context), layoutToInflate(), null, false)
    }

    protected val viewModel: VM by viewModels(getViewModelClass())

    protected val debouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    protected val insetsCollapseListener: InsetsListener by lazy { InsetsListener() }

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass() : KClass<VM>

    abstract fun doOnCreated()

    open fun getArguments(arguments: Bundle) {}

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        dialog?.requestWindowFeature(Window.FEATURE_NO_TITLE)
        initDataBinding()
        if (viewModel is LifecycleObserver)lifecycle.addObserver(viewModel as LifecycleObserver)
        arguments?.let {
            getArguments(it)
        }

        doOnCreated()
        return dataBinding.root
    }

    override fun onDestroy() {
        dataBinding.unbind()
        super.onDestroy()
    }

    private fun initDataBinding() {
        dataBinding.lifecycleOwner = this
    }

    fun show(fragment: Fragment) {
        show(fragment.childFragmentManager, javaClass.name)
    }

    fun show(activity: AppCompatActivity) {
        show(activity.supportFragmentManager, javaClass.name)
    }

    fun showForResult(fragment: Fragment, requestCode: Int) {
        setTargetFragment(fragment, requestCode)
        show(fragment.parentFragmentManager, javaClass.name)
    }

    fun showForResult(activity: BaseActivity<*,*>, requestCode: Int) {
        var args = arguments
        if (args == null)
            args = Bundle()
        args.putInt(activity.javaClass.name + "requestCode", requestCode)
        arguments = args
        show(activity.supportFragmentManager, javaClass.name)
    }

    protected fun setResult(resultCode: Int) {
        setResult(resultCode, Intent())
    }

    protected fun setResult(resultCode: Int, data: Intent) {
        var callback: Callback? = null
        var requestCode = 0

        val fragment = targetFragment
        if (fragment != null && fragment is Callback) {
            callback = fragment
            requestCode = targetRequestCode
        } else if (fragment == null) {
            val activity = activity
            if (activity != null && activity is Callback) {
                callback = activity
                requestCode = requireArguments().getInt(activity.javaClass.name + "requestCode")
            }
        }

        callback?.onDialogResult(requestCode, resultCode, data)
    }

}