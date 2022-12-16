package ${configs.packageName}.data.common

enum class GrantType(val value: String) {
    PASSWORD("password"),
    REFRESH("refresh_token"),
    CODE("authorization_code")
}