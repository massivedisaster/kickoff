package ${configs.packageName}.utils.authentication

import android.accounts.Account
import android.accounts.AccountManager
import android.accounts.AccountManagerCallback
import android.content.Context
import android.os.Build
import android.os.Bundle

object AccountHelper {
    
    private const val MISSING_PERMISSION = "MissingPermission"
    private var manager: AccountManager? = null
    private var deletedAccounts: Int = 0
    
    fun initialize(context: Context) {
        manager = AccountManager.get(context)
    }
    
    /**
     * Add a new account to the account manager
     *
     * @param context  The application context.
     * @param name     The account name.
     * @param password The account password.
     * @param token    The account token.
     */
    fun addAccount(context: Context, name: String?, password: String?, token: String?) {
        validateAccountManager()
        clearAccounts(context) {
            onFinished(name, context, password, token)
        }
    }
    
    /**
     * Add a new account to the account manager
     *
     * @param context  The application context.
     * @param name     The account name.
     * @param password The account password.
     * @param token    The account token.
     */
    private fun onFinished(name: String?, context: Context, password: String?, token: String?) {
        val account = Account(name, context.packageName)
        manager?.addAccountExplicitly(account, password, null)
        manager?.setAuthToken(account, context.packageName, token)
    }
    
    /**
     * Remove accounts from manager.
     *
     * @param context           The application context.
     * @param onAccountListener The listener to be called when process finished.
     */
    fun clearAccounts(context: Context, onFinished: () -> Unit = {}) {
        synchronized(AccountHelper::class.java) {
            validateAccountManager()
            deletedAccounts = 0
            val accounts = manager!!.getAccountsByType(context.packageName)
            if (accounts.isEmpty()) {
                onFinished()
               return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                for (acc in accounts) {
                    manager!!.removeAccountExplicitly(acc)
                }
                onFinished()
            } else {
                removeAccounts(onFinished, *accounts)
            }
        }
    }
    
    /**
     * Remove accounts from manager.
     *
     * @param onAccountListener The listener to be called when process finished.
     * @param accounts          The array of accounts to be removed.
     */
    private fun removeAccounts(onAccount: () -> Unit, vararg accounts: Account) {
        validateAccountManager()
        for (account in accounts) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                val callback: AccountManagerCallback<Bundle> = AccountCallback(++deletedAccounts, accounts.size, onAccount)
                manager!!.removeAccount(account, null, callback, null)
            } else {
                val callback: AccountManagerCallback<Boolean> = AccountCallback(++deletedAccounts, accounts.size, onAccount)
                manager!!.removeAccount(account, callback, null)
            }
        }
    }
    
    /**
     * Verify if the application have a account and retrieve the account.
     *
     * @param context The application context.
     * @return The current account or null if there is no account.
     */
    fun getCurrentAccount(context: Context): Account? {
        validateAccountManager()
        val accounts = manager!!.getAccountsByType(context.packageName)
        return if (accounts.isNotEmpty()) accounts[0] else null
    }
    
    /**
     * Verify if the application have an account and retrieve the account password.
     *
     * @param account The account.
     * @return The user password.
     */
    fun getAccountPassword(account: Account?): String {
        validateAccountManager()
        return manager!!.getPassword(account)
    }
    
    /**
     * Change the account password.
     *
     * @param account  The account.
     * @param password The new password.
     */
    fun setAccountPassword(account: Account?, password: String?) {
        validateAccountManager()
        manager!!.setPassword(account, password)
    }
    
    /**
     * Retrieve the account token.
     *
     * @param account The account account to take the token.
     * @param context The application context.
     * @return The account token.
     */
    fun getCurrentToken(account: Account, context: Context): String? {
        validateAccountManager()
        return manager!!.peekAuthToken(account, context.packageName)
    }
    
    /**
     * Verify if manager was initialized.
     *
     * @throws ExceptionInInitializerError if <var>manager</var> is null
     */
    private fun validateAccountManager() {
        if (manager == null) {
            throw ExceptionInInitializerError("It's necessary to call AccountHelper.initialize first")
        }
    }
    
    /**
     * Method to associate information to the user.
     *
     * @param account The account.
     * @param key     Key of the information.
     * @param value   The information to be associated.
     */
    fun setUserData(account: Account, key: String?, value: String?) {
        validateAccountManager()
        manager!!.setUserData(account, key, value)
    }
    
    /**
     * Method to get previous associated information to the user.
     *
     * @param account The account.
     * @param key     Key of the information.
     * @return The information associated.
     */
    fun getUserData(account: Account, key: String?): String? {
        validateAccountManager()
        return manager!!.getUserData(account, key)
    }
    
}