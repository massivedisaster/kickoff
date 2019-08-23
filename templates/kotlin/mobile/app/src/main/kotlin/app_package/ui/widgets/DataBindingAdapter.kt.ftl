package ${configs.packageName}.ui.widgets

import android.view.View
import androidx.databinding.BindingAdapter

object DataBindingAdapter {

    @JvmStatic
    @BindingAdapter("bind:show")
    fun show(view: View, show: Boolean) {
        view.showCondition(show)
    }

}