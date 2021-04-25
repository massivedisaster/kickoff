package ${configs.packageName}.utils.authentication

import android.accounts.AccountManagerCallback
import android.accounts.AccountManagerFuture

class AccountCallback<T>(private val deletedAccounts: Int, private val accountsLength: Int, private val onAccount: () -> Unit = {}) : AccountManagerCallback<T> {
    
    override fun run(future: AccountManagerFuture<T>) {
        if (deletedAccounts == accountsLength) {
            onAccount()
        }
    }
    
}