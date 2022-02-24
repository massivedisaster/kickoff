package ${configs.packageName}.utils.helper.extensions

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.TypedArray
import android.graphics.Color
import android.graphics.Point
import android.os.Build
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import androidx.activity.ComponentActivity
import androidx.annotation.MainThread
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.createViewModelLazy
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.CreationExtras
import ${configs.packageName}.utils.helper.DebounceTimer
import kotlin.reflect.KClass

/**
 * starts an activity using a debouncer (fast click avoidance)
 */
fun FragmentActivity.startActivityDebounced(intent : Intent, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivity(intent)
    }
}

/**
 * starts an activity for result using a debouncer (fast click avoidance)
 */
fun FragmentActivity.startActivityForResultDebounced(intent : Intent, requestCode : Int, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivityForResult(intent, requestCode)
    }
}

/**
 * returns screen width
 */
fun FragmentActivity.getDisplayWidth(): Int {
    val size = Point()
    windowManager.defaultDisplay.getSize(size)

    return size.x
}

/**
 * returns screen height
 */
fun FragmentActivity.getDisplayHeight(): Int {
    val size = Point()
    windowManager.defaultDisplay.getSize(size)

    return size.y
}

fun Activity.setSystemBarTransparent() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        val window = this.window
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
        window.statusBarColor = Color.TRANSPARENT
    }
}


/**
 * returns actionBar default size (similar to ?attr/actionBarSize)
 */
fun FragmentActivity.actionBarSize(): Float {
    val styledAttributes: TypedArray = theme.obtainStyledAttributes(IntArray(1) { android.R.attr.actionBarSize })
    val actionBarSize = styledAttributes.getDimension(0, 0F)
    styledAttributes.recycle()
    return actionBarSize
}


private const val HIDE_SOFT_INPUT_FLAGS_NONE = 0

/**
 * hides keyboard for current focused activity
 */
fun FragmentActivity.hideKeyboard() {
    currentFocus?.let {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(it.windowToken, HIDE_SOFT_INPUT_FLAGS_NONE)
    }
}

/**
 * hides keyboard for current focused activity
 */
fun FragmentActivity.openKeyboard() {
    currentFocus?.let {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY)
    }
}

@MainThread
fun <VM : ViewModel> ComponentActivity.viewModels(viewModelClass: KClass<VM>)
        = ViewModelLazy(viewModelClass, { viewModelStore }, { defaultViewModelProviderFactory }, { this.defaultViewModelCreationExtras })

@MainThread
fun <VM : ViewModel> Fragment.viewModels(
    viewModelClass: KClass<VM>,
    ownerProducer: () -> ViewModelStoreOwner = { this }
): Lazy<VM> {
    val owner by lazy(LazyThreadSafetyMode.NONE) { ownerProducer() }
        return createViewModelLazy(
        viewModelClass,
        { owner.viewModelStore },
        { (owner as? HasDefaultViewModelProviderFactory)?.defaultViewModelCreationExtras ?: CreationExtras.Empty },
        { (owner as? HasDefaultViewModelProviderFactory)?.defaultViewModelProviderFactory ?: defaultViewModelProviderFactory }
    )
}
