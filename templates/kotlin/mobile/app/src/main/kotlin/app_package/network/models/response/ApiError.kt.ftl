package ${configs.packageName}.network.models.response

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.*

@JsonIgnoreProperties(ignoreUnknown = true)
data class ApiError(
        @JsonProperty("status") val status: Int,
        @JsonProperty("title") val title: String?,
        @JsonProperty("details") val details: String?
)