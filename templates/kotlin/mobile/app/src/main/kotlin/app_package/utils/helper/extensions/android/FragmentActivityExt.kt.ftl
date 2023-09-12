package ${configs.packageName}.utils.helper.extensions.android

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.TypedArray
import android.graphics.Color
import android.os.Build
import android.util.DisplayMetrics
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import androidx.activity.ComponentActivity
import androidx.annotation.MainThread
import androidx.core.app.TaskStackBuilder
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.createViewModelLazy
import androidx.lifecycle.HasDefaultViewModelProviderFactory
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelLazy
import androidx.lifecycle.ViewModelStoreOwner
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
 * returns screen size
 */
@Suppress("DEPRECATION")
fun Activity.getDisplaySize(): Pair<Int, Int> {
    val outMetrics = DisplayMetrics()

    return when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val bounds = windowManager.currentWindowMetrics.bounds
            Pair(bounds.width(), bounds.height())
        }
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.R -> {
            display?.getRealMetrics(outMetrics)
            Pair(outMetrics.widthPixels, outMetrics.heightPixels)
        }
        else -> {
            windowManager.defaultDisplay.getMetrics(outMetrics)
            Pair(outMetrics.widthPixels, outMetrics.heightPixels)
        }
    }
}

fun Activity.setSystemBarTransparent() {
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.statusBarColor = Color.TRANSPARENT
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

/**
 * starts an activity using a debouncer (fast click avoidance)
 */
fun Fragment.startActivityDebounced(intent : Intent, debounceTimer: DebounceTimer) {
    debounceTimer.debounceRunFirst {
        startActivity(intent)
    }
}

/**
 * returns actionBar default size (similar to ?attr/actionBarSize)
 */
fun Fragment.actionBarSize(): Float {
    val styledAttributes = activity?.theme?.obtainStyledAttributes(IntArray(1) { android.R.attr.actionBarSize })
    val actionBarSize = styledAttributes?.getDimension(0, 0F)
    styledAttributes?.recycle()
    return actionBarSize ?: 0F
}

fun Activity.navigateToStack(vararg intents: Intent, start: Boolean = true) {
    val stack = TaskStackBuilder.create(this)
    intents.forEach { nextIntent -> stack.addNextIntent(nextIntent) }
    if (start) { stack.startActivities() }
}