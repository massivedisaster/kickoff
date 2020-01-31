package ${configs.packageName}.ui.dialog

import android.graphics.drawable.ColorDrawable
import androidx.core.content.ContextCompat
import androidx.transition.Fade
import ${configs.packageName}.R
import ${configs.packageName}.databinding.DialogLoadingBinding
import ${configs.packageName}.ui.base.BaseDialog

class LoadingDialog : BaseDialog<DialogLoadingBinding, LoadingViewModel>() {

    override fun layoutToInflate() = R.layout.dialog_loading

    override fun getViewModelClass() = LoadingViewModel::class.java

    override fun doOnCreated() {
        isCancelable = false
        dialog?.window!!.setBackgroundDrawable(ColorDrawable(ContextCompat.getColor(context!!, android.R.color.transparent)))
    }

    override fun setEnterTransition(transition: Any?) {
        val transit = Fade()
        transit.mode = Fade.MODE_IN
        transit.duration = 500
        super.setEnterTransition(transition)
    }

    override fun setExitTransition(transition: Any?) {
        val transit = Fade()
        transit.mode = Fade.MODE_OUT
        transit.duration = 500
        super.setExitTransition(transit)
    }

}
