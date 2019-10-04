package ${configs.packageName}.utils.authentication

import android.app.Application
import com.massivedisaster.adal.account.AccountHelper
import ${configs.packageName}.network.models.response.TokenModel
import ${configs.packageName}.utils.manager.PreferencesManager
import java.util.concurrent.atomic.AtomicBoolean
import javax.inject.Inject

class AccountUtils @Inject constructor(private val application: Application, private val preferencesManager: PreferencesManager) {

    val refreshingToken = AtomicBoolean(false)

    companion object {
        val TOKEN = "TOKEN"
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
    fun getToken() = getCurrentAccount()?.let { AccountHelper.getCurrentToken(it, application) }
    fun getRefreshToken() = getCurrentAccount()?.let { AccountHelper.getUserData(it, REFRESH_TOKEN) }
    fun setRefreshToken(refreshToken: String) = getCurrentAccount()?.let { AccountHelper.setUserData(it, REFRESH_TOKEN, refreshToken) }

    fun clear(listener: () -> Unit) {
        AccountHelper.clearAccounts(application, listener)
    }

    fun isLogged() = getToken()?.isNotEmpty() ?: false

}