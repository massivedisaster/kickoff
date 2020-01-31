package ${configs.packageName}.network.models.response

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
data class TokenModel(
        @JsonProperty("accessToken") val accessToken: String,
        @JsonProperty("refreshToken") val refreshToken: String
)