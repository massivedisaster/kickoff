package ${configs.packageName}.ui.base

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModel
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import ${configs.packageName}.utils.helper.DebounceTimer
import ${configs.packageName}.utils.helper.InsetsListener
import ${configs.packageName}.utils.helper.extensions.viewModels
import kotlin.reflect.KClass


abstract class BaseBottomSheetDialogFragment<T : ViewDataBinding, VM : ViewModel> : BottomSheetDialogFragment() {

    protected val dataBinding: T by lazy {
        DataBindingUtil.inflate<T>(LayoutInflater.from(context), layoutToInflate(), null, false)
    }

    protected val viewModel: VM by viewModels(getViewModelClass())

    protected val debouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    protected val insetsCollapseListener: InsetsListener by lazy { InsetsListener() }

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass(): KClass<VM>

    open fun getStyle(): Pair<Int, Int>? = null

    abstract fun doOnCreated()

    open fun getArguments(arguments: Bundle) {}

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        getStyle()?.let {
            setStyle(it.first, it.second)
        }
    }

    lateinit var modalBottomSheetBehavior : BottomSheetBehavior<*>

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        initDataBinding()

        if (viewModel is LifecycleObserver) lifecycle.addObserver(viewModel as LifecycleObserver)

        modalBottomSheetBehavior = (dialog as BottomSheetDialog).behavior

        if (arguments != null) {
            getArguments(requireArguments())
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
        show(fragment.parentFragmentManager, javaClass.name)
    }

    fun show(activity: AppCompatActivity) {
        show(activity.supportFragmentManager, javaClass.name)
    }

    fun showForResult(fragment: Fragment, requestCode: Int) {
        setTargetFragment(fragment, requestCode)
        show(fragment.parentFragmentManager, javaClass.name)
    }

    fun showForResult(activity: BaseActivity<*, *>, requestCode: Int) {
        var args = arguments
        if (args == null)
            args = Bundle()
        args.putInt(activity.javaClass.name + "requestCode", requestCode)
        arguments = args
        show(activity.supportFragmentManager, javaClass.name)
    }
}