package ${configs.packageName}.utils.manager

import android.app.AlertDialog
import android.app.TimePickerDialog
import android.content.Context
import androidx.annotation.StringRes
import ${configs.packageName}.R
import java.util.*
import javax.inject.Inject
import kotlin.collections.LinkedHashMap

class DialogManager @Inject constructor() {

    private fun generateDialog(context: Context, title: String?, message: String?, positive: String?, negative: String?, option: Boolean, success: () -> Unit = {}, cancel: () -> Unit = {}): AlertDialog {
        val builder = AlertDialog.Builder(context)
        builder.setMessage(message)
        builder.setTitle(title)
                .setPositiveButton(positive) { dialog, _ ->
                    success()
                    dialog.dismiss()
                }

        if (option) {
            builder.setNegativeButton(negative) { dialog, _ ->
                cancel()
                dialog.dismiss()
            }
        }

        builder.setOnCancelListener {
            cancel()
        }
        return builder.create()
    }

    fun generateConfirmationDialog(context: Context, title: String?, message: String?) = generateDialog(context, title, message, context.getString(android.R.string.ok), null, false)

    fun generateConfirmationDialog(context: Context, title: String?, message: String?, positive: String?) = generateDialog(context, title, message, positive, null, false)

    fun generateOptionDialog(context: Context, title: String?, message: String?) = generateDialog(context, title, message, context.getString(android.R.string.yes), context.getString(android.R.string.no), true)

    fun generateOptionDialog(context: Context, title: String?, message: String?, positive: String?, negative: String?) = generateDialog(context, title, message, positive, negative, true)

    fun generateConfirmationDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(android.R.string.ok), null, false)

    fun generateConfirmationDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, @StringRes positiveId: Int) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(positiveId), null, false)

    fun generateOptionDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(android.R.string.yes), context.getString(android.R.string.no), true)

    fun generateOptionDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, @StringRes positiveId: Int, @StringRes negativeId: Int) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(positiveId), context.getString(negativeId), true)

    fun generateConfirmationDialog(context: Context, title: String?, message: String?, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, title, message, context.getString(android.R.string.ok), null, false, success, cancel)

    fun generateConfirmationDialog(context: Context, title: String?, message: String?, positive: String?, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, title, message, positive, null, false, success, cancel)

    fun generateOptionDialog(context: Context, title: String?, message: String?, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, title, message, context.getString(android.R.string.yes), context.getString(android.R.string.no), true, success, cancel)

    fun generateOptionDialog(context: Context, title: String?, message: String?, positive: String?, negative: String?, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, title, message, positive, negative, true, success, cancel)

    fun generateConfirmationDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(android.R.string.ok), null, false, success, cancel)

    fun generateConfirmationDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, @StringRes positiveId: Int, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(positiveId), null, false, success, cancel)

    fun generateOptionDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(android.R.string.yes), context.getString(android.R.string.no), true, success, cancel)

    fun generateOptionDialog(context: Context, @StringRes titleId: Int, @StringRes messageId: Int, @StringRes positiveId: Int, @StringRes negativeId: Int, success: () -> Unit = {}, cancel: () -> Unit = {}) = generateDialog(context, context.getString(titleId), context.getString(messageId), context.getString(positiveId), context.getString(negativeId), true, success, cancel)

    fun generateTimePicker(context: Context, hour: Int = -1, minutes: Int = -1, listener: (String) -> Unit) {
        var selectedHour = hour
        var selectMinutes = minutes

        if (selectedHour == -1 || selectMinutes == -1) {
            val calendar = Calendar.getInstance()
            selectedHour = calendar.get(Calendar.HOUR_OF_DAY)
            selectMinutes = calendar.get(Calendar.MINUTE)
        }

        TimePickerDialog(context, TimePickerDialog.OnTimeSetListener { _, hourOfDay, minute -> listener(String.format("%02d:%02d", hourOfDay, minute)) }, selectedHour, selectMinutes, true ).show()
    }

}