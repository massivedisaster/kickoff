package ${configs.packageName}.utils.authentication

import android.accounts.AbstractAccountAuthenticator
import android.accounts.Account
import android.accounts.AccountAuthenticatorResponse
import android.accounts.AccountManager.KEY_ERROR_CODE
import android.accounts.AccountManager.KEY_ERROR_MESSAGE
import android.content.Context
import android.os.Bundle
import ${configs.packageName}.R

class AccountAuthenticator(private val context: Context) : AbstractAccountAuthenticator(context) {
    
    companion object {
        private const val ERROR_CODE_ONE_ACCOUNT_ALLOWED = 1001
    }
    
    override fun addAccount(response: AccountAuthenticatorResponse, accountType: String, authTokenType: String?, requiredFeatures: Array<out String>?,
                            options: Bundle): Bundle? {
        if (AccountHelper.getCurrentAccount(context) != null) {
            val result = Bundle()
    
            result.putInt(KEY_ERROR_CODE, ERROR_CODE_ONE_ACCOUNT_ALLOWED);
            result.putString(KEY_ERROR_MESSAGE, context.getString(R.string.error_account_only_one_allowed));
            
            return result
        }
        
        return null
    }
    
    override fun confirmCredentials(response: AccountAuthenticatorResponse, account: Account, options: Bundle?) = null
    
    override fun editProperties(response: AccountAuthenticatorResponse?, accountType: String?) = null
    
    override fun getAuthToken(response: AccountAuthenticatorResponse, account: Account, authTokenType: String, options: Bundle) = null
    
    override fun getAuthTokenLabel(authTokenType: String) = null
    
    override fun hasFeatures(response: AccountAuthenticatorResponse, account: Account, features: Array<out String>) = null
    
    override fun updateCredentials(response: AccountAuthenticatorResponse, account: Account, authTokenType: String, options: Bundle?) = null

}