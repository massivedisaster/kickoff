package ${configs.packageName}.utils.authentication

import android.app.Application
import com.massivedisaster.adal.account.AccountHelper
import ${configs.packageName}.network.models.response.TokenModel
import ${configs.packageName}.utils.manager.PreferencesManager
import java.util.concurrent.atomic.AtomicBoolean
import javax.inject.Inject

class AccountUtils @Inject constructor(private val application: Application, private val preferencesManager: PreferencesManager) {


    companion object {
        //making singleton in dagger is not working must be global var
        val refreshingToken = AtomicBoolean(false)

        val ACCESS_TOKEN = "ACCESS_TOKEN"
        val REFRESH_TOKEN = "REFRESH_TOKEN"
    }

    init {
        AccountHelper.initialize(application)
    }

    fun storeAccount(username: String, password: String, authenticationModel: TokenModel) {
        AccountHelper.addAccount(application, username, password, authenticationModel.accessToken)
        updateAccount(authenticationModel)
    }

    fun updateAccount(authenticationModel: TokenModel) {
        setAccessToken(authenticationModel.accessToken)
        setRefreshToken(authenticationModel.refreshToken)
    }

    fun getCurrentAccount() = try {
        AccountHelper.getCurrentAccount(application)
    } catch (e: Exception) {
        null
    }

    fun removeAccount() {
        AccountHelper.clearAccounts(application, null)
        preferencesManager.deleteAll()
    }

    fun getPassword() = getCurrentAccount()?.let { AccountHelper.getAccountPassword(it) }
    fun getUsername() = getCurrentAccount()?.let { it.name }

    fun getAccessToken() = getCurrentAccount()?.let { AccountHelper.getUserData(it, ACCESS_TOKEN) }
    fun setAccessToken(accessToken: String) = getCurrentAccount()?.let { AccountHelper.setUserData(it, ACCESS_TOKEN, accessToken) }

    fun getRefreshToken() = getCurrentAccount()?.let { AccountHelper.getUserData(it, REFRESH_TOKEN) }
    fun setRefreshToken(refreshToken: String) = getCurrentAccount()?.let { AccountHelper.setUserData(it, REFRESH_TOKEN, refreshToken) }

    fun clear(listener: () -> Unit) {
        AccountHelper.clearAccounts(application, listener)
    }

    fun isLogged() = getAccessToken()?.isNotEmpty() ?: false

}