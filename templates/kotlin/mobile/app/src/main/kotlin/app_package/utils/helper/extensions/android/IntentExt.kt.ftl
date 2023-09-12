package ${configs.packageName}.utils.helper.extensions.android

import android.content.Intent
import android.os.Bundle

fun Intent.applyNewClearFlags() = this.apply {
    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
}

fun Intent.applyArgumentsBundle(argumentsBundle: Bundle) = this.apply {
    putExtras(argumentsBundle)
}