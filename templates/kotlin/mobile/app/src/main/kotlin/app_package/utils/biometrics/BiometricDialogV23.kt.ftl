package ${configs.packageName}.utils.biometrics

import android.content.Context
import android.content.DialogInterface
import android.view.View
import android.widget.Button
import android.widget.TextView
import com.google.android.material.bottomsheet.BottomSheetDialog
import ${configs.packageName}.R

class BiometricDialogV23 : BottomSheetDialog, View.OnClickListener {

    private var btnCancel: Button? = null
    private var itemTitle: TextView? = null
    private var itemDescription: TextView? = null
    private var itemSubtitle: TextView? = null
    private var itemStatus: TextView? = null

    private var biometricCallback: BiometricCallback? = null

    constructor(context: Context) : super(context, R.style.BottomSheetDialogTheme) {
        setDialogView()
    }
    constructor(context: Context, biometricCallback: BiometricCallback) : super(context, R.style.BottomSheetDialogTheme) {
        this.biometricCallback = biometricCallback
        setDialogView()
    }
    constructor(context: Context, cancelable: Boolean, cancelListener: DialogInterface.OnCancelListener) : super(context, cancelable, cancelListener)

    private fun setDialogView() {
        val bottomSheetView = layoutInflater.inflate(R.layout.biometric_view_bottom_sheet, null)
        setContentView(bottomSheetView)

        btnCancel = findViewById(R.id.btn_cancel)
        btnCancel!!.setOnClickListener(this)

        itemTitle = findViewById(R.id.item_title)
        itemStatus = findViewById(R.id.item_status)
        itemSubtitle = findViewById(R.id.item_subtitle)
        itemDescription = findViewById(R.id.item_description)
    }

    fun setTitle(title: String) {
        itemTitle!!.text = title
    }

    fun updateStatus(status: String) {
        itemStatus!!.text = status
    }

    fun setSubtitle(subtitle: String) {
        if (!subtitle.isEmpty()) {
            itemSubtitle!!.visibility = View.VISIBLE
            itemSubtitle!!.text = subtitle
        } else {
            itemSubtitle!!.visibility = View.GONE
        }

    }

    fun setDescription(description: String) {
        itemDescription!!.text = description
    }

    fun setButtonText(negativeButtonText: String) {
        btnCancel!!.text = negativeButtonText
    }

    override fun onClick(view: View) {
        dismiss()
        biometricCallback?.onAuthenticationCancelled()
    }

}
