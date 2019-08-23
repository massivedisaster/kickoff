package ${configs.packageName}.data.common

import androidx.annotation.StringDef

@Retention(AnnotationRetention.SOURCE)
@StringDef(GrantTypes.PASSWORD, GrantTypes.REFRESH)
annotation class GrantType

object GrantTypes {
    const val PASSWORD = "password"
    const val REFRESH = "refresh_token"
}