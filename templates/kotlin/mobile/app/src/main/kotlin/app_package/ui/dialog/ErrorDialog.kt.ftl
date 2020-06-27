package ${configs.packageName}.ui.dialog

import android.app.Dialog
import android.content.DialogInterface
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.WindowManager
import androidx.core.content.ContextCompat
import androidx.transition.Fade
import ${configs.packageName}.R
import ${configs.packageName}.databinding.DialogErrorBinding
import ${configs.packageName}.ui.base.BaseDialog
import ${configs.packageName}.utils.helper.extensions.removeView

class ErrorDialog : BaseDialog<DialogErrorBinding, ErrorDialogViewModel>() {

    companion object {
        private val TITLE = "TITLE"
        private val MESSAGE = "MESSAGE"
        private val BUTTONOKTEXT = "BUTTONOKTEXT"
        private val BUTTONCANCELTEXT = "BUTTONCANCELTEXT"

        fun newInstance(title: String, message: String,
                        buttonOkText: String, buttonOkExecution: (() -> Unit)? = null,
                        buttonCancelText: String? = null, cancelExecution: (() -> Unit)? = null): ErrorDialog {
            val args = Bundle()

            args.putString(TITLE, title)
            args.putString(MESSAGE, message)
            args.putString(BUTTONOKTEXT, buttonOkText)
            args.putString(BUTTONCANCELTEXT, buttonCancelText)

            val fragment = ErrorDialog()
            fragment.arguments = args

            fragment.buttonOkExecution = buttonOkExecution
            fragment.cancelExecution = cancelExecution

            return fragment
        }
    }

    var buttonOkExecution: (() -> Unit)? = null
    var cancelExecution: (() -> Unit)? = null

    private var title: String? = null
    private var message: String? = null
    private var okButton: String? = null
    private var cancelButton: String? = null

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = Dialog(context!!, android.R.style.Theme_Translucent_NoTitleBar)
        //setStyle(R.style.fullScreenDialog, 0)
        //dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.window!!.setBackgroundDrawable(ColorDrawable(ContextCompat.getColor(context!!, R.color.dialog_background)))
        dialog.window!!.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT)
        return dialog
    }

    override fun layoutToInflate() = R.layout.dialog_error

    override fun getViewModelClass() = ErrorDialogViewModel::class.java

    override fun getArguments(arguments: Bundle) {
        title = arguments.getString(TITLE)
        message = arguments.getString(MESSAGE)
        okButton = arguments.getString(BUTTONOKTEXT)
        cancelButton = arguments.getString(BUTTONCANCELTEXT)
    }

    override fun doOnCreated() {
        isCancelable = true

        dataBinding.dialogErrorTitle.text = title
        dataBinding.dialogErrorMessage.text = message
        dataBinding.btnOk.text = okButton
        dataBinding.btnCancel.text = cancelButton

        if (cancelButton == null) {
            dataBinding.btnCancel.removeView()
        }

        dataBinding.btnOk.setOnClickListener {
            if(buttonOkExecution != null) {
                buttonOkExecution!!.invoke()
                dismiss()
            } else {
                dismiss()
            }
        }
        dataBinding.btnCancel.setOnClickListener {
            if(cancelExecution != null) {
                cancelExecution!!.invoke()
                dismiss()
            } else {
                dismiss()
            }
        }

        dataBinding.bkg.setOnClickListener {
            dismiss()
        }
    }

    override fun onDismiss(dialog: DialogInterface) {
        super.onDismiss(dialog)
        cancelExecution?.invoke()
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
