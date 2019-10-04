package ${configs.packageName}.utils.helper

import android.content.Context
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import javax.inject.Inject

class PermissionHelper @Inject constructor() {

    fun checkPermissions(context: Context, permissions: Array<String>): Boolean {
        permissions.forEach { permission ->
            if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                return false
            }
        }
        return true
    }

}