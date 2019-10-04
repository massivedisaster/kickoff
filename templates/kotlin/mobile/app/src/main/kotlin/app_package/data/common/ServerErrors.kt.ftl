package ${configs.packageName}.data.common

import androidx.annotation.IntDef

@Retention(AnnotationRetention.SOURCE)
@IntDef(ServerErrors.NO_INTERNET, ServerErrors.EMPTY_BODY, ServerErrors.TIMEOUT, ServerErrors.GENERAL, ServerErrors.API)
annotation class ServerError

object ServerErrors {
    const val NO_INTERNET = 0
    const val EMPTY_BODY = 1
    const val TIMEOUT = 2
    const val GENERAL = 3
    const val API = 4
}