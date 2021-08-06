package ${configs.packageName}.ui.base

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasAndroidInjector
import dagger.android.support.AndroidSupportInjection
import ${configs.packageName}.utils.helper.DebounceTimer
import javax.inject.Inject

/*
sample
Fragment or Activity that will show the bottom sheet
class ParentFragment : BaseFragment<FragmentParentBinding, ParentViewModel>(), BaseBottomSheetDialogFragment.BottomSheetDialogResult<<name>Result> {
    override fun onResult(result: <name>Result) {
        //handle bottom sheet result here
    }
}

The bottom sheet
class <name>BottomDialogFragment : BaseBottomSheetDialogFragment<<name>Result, <layout>Binding, <parent>ViewModel>() {

    override fun layoutToInflate() = R.layout.<layout>

    override fun getViewModelClass() = <parent>ViewModel::class.java

    override fun getStyle(): Pair<Int, Int> = Pair(DialogFragment.STYLE_NORMAL, R.style.BottomSheetDialog)

    override fun doOnCreated() {

    }
}
 */
abstract class BaseBottomSheetDialogFragment<ResultType, T : ViewDataBinding, VM : ViewModel> : BottomSheetDialogFragment(), HasAndroidInjector {

    interface BottomSheetDialogResult<ResultType> {
        fun onResult(obj: ResultType)
    }


    @Inject
    lateinit var androidInjector: DispatchingAndroidInjector<Any>

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    protected val dataBinding: T by lazy {
        DataBindingUtil.inflate<T>(LayoutInflater.from(context), layoutToInflate(), null, false)
    }

    protected val viewModel: VM by lazy {
        ViewModelProvider(activity as FragmentActivity, viewModelFactory).get(getViewModelClass())
    }


    protected val clickDebouncer: DebounceTimer by lazy { DebounceTimer(lifecycle) }

    @LayoutRes
    abstract fun layoutToInflate(): Int

    abstract fun getViewModelClass(): Class<VM>

    abstract fun getStyle(): Pair<Int, Int>?

    abstract fun doOnCreated()

    override fun androidInjector() = androidInjector

    open fun getArguments(arguments: Bundle) {}


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        getStyle()?.let {
            setStyle(it.first, it.second)
        }


    }

    lateinit var modalBottomSheetBehavior : BottomSheetBehavior<*>

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        AndroidSupportInjection.inject(this)
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

    protected fun setResult(obj: ResultType) {
        var callback: BottomSheetDialogResult<ResultType>? = null
        var requestCode = 0

        val fragment = targetFragment
        if (fragment != null && fragment is BottomSheetDialogResult<*>) {
            callback = fragment as BottomSheetDialogResult<ResultType>
            requestCode = targetRequestCode
        } else if (fragment == null) {
            val activity = activity
            if (activity != null && activity is BottomSheetDialogResult<*>) {
                callback = activity as BottomSheetDialogResult<ResultType>
                requestCode = requireArguments().getInt(activity.javaClass.name + "requestCode")
            }
        }

        callback?.onResult(obj)
    }
}