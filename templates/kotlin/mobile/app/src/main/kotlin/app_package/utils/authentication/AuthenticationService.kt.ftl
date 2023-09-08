package ${configs.packageName}.utils.authentication

import android.app.Service
import android.content.Intent

class AuthenticationService : Service() {
    
    override fun onBind(intent: Intent?) = AccountAuthenticator(this).iBinder
    
}