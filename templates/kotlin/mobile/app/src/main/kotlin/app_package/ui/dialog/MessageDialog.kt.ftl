package ${configs.packageName}.ui.dialog

import android.app.Dialog
import android.content.DialogInterface
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.WindowManager
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import androidx.core.content.ContextCompat
import androidx.transition.Fade
import dagger.hilt.android.AndroidEntryPoint
import ${configs.packageName}.R
import ${configs.packageName}.databinding.DialogMessageBinding
import ${configs.packageName}.ui.base.BaseDialog
import ${configs.packageName}.utils.helper.extensions.onClickDebounce
import ${configs.packageName}.utils.helper.extensions.removeView
import ${configs.packageName}.utils.helper.extensions.showCondition

@AndroidEntryPoint
class MessageDialog : BaseDialog<DialogMessageBinding, MessageViewModel>() {

    companion object {
        private const val MESSAGE = "MESSAGE"
        private const val ICON = "ICON"
        private const val CLOSE = "CLOSE"
        private const val BUTTON_OK_TEXT = "BUTTON_OK_TEXT"
        private const val BUTTON_CANCEL_TEXT = "BUTTON_CANCEL_TEXT"

        fun newInstance(@StringRes message: Int, @DrawableRes icon: Int, @StringRes buttonOkText: Int, buttonOkExecution: (() -> Unit)? = null,
                        @StringRes buttonCancelText: Int = -1, cancelExecution: (() -> Unit)? = null, close: Boolean = false): MessageDialog {
            val args = Bundle()

            args.putInt(MESSAGE, message)
            args.putInt(ICON, icon)
            args.putBoolean(CLOSE, close)
            args.putInt(BUTTON_OK_TEXT, buttonOkText)
            args.putInt(BUTTON_CANCEL_TEXT, buttonCancelText)

            val fragment = MessageDialog()
            fragment.arguments = args

            fragment.buttonOkExecution = buttonOkExecution
            fragment.cancelExecution = cancelExecution

            return fragment
        }
    }

    var buttonOkExecution: (() -> Unit)? = null
    var cancelExecution: (() -> Unit)? = null
    private var close: Boolean = false
    @StringRes private var message: Int = -1
    @DrawableRes private var icon: Int = -1
    @StringRes private var okButton: Int = -1
    @StringRes private var cancelButton: Int = -1

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = Dialog(requireContext(), android.R.style.Theme_Translucent_NoTitleBar)
        dialog.window!!.setBackgroundDrawable(ColorDrawable(ContextCompat.getColor(requireContext(), R.color.dialog_background)))
        dialog.window!!.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT)
        return dialog
    }

    override fun layoutToInflate() = R.layout.dialog_message

    override fun getViewModelClass() = MessageViewModel::class

    override fun getArguments(arguments: Bundle) {
        close = arguments.getBoolean(CLOSE, false)
        icon = arguments.getInt(ICON, -1)
        message = arguments.getInt(MESSAGE, -1)
        okButton = arguments.getInt(BUTTON_OK_TEXT, -1)
        cancelButton = arguments.getInt(BUTTON_CANCEL_TEXT, -1)
    }

    override fun doOnCreated() {
        isCancelable = false

        dataBinding.dialogErrorImage.setImageResource(icon)
        dataBinding.message.text = getString(message)
        dataBinding.btnOk.text = getString(okButton)

        if (cancelButton == -1) {
            dataBinding.btnCancel.removeView()
        } else {
            dataBinding.btnCancel.text = getString(cancelButton)
        }

        dataBinding.dismissButton.showCondition(close)
        dataBinding.dismissButton.onClickDebounce(debouncer) {
            dismiss()
        }

        dataBinding.btnOk.onClickDebounce(debouncer) {
            if(buttonOkExecution != null) {
                buttonOkExecution!!.invoke()
                dismiss()
            } else {
                dismiss()
            }
        }
        dataBinding.btnCancel.onClickDebounce(debouncer) {
            if(cancelExecution != null) {
                cancelExecution!!.invoke()
                dismiss()
            } else {
                dismiss()
            }
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