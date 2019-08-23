package ${configs.packageName}.network.models.response

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.*

@JsonIgnoreProperties(ignoreUnknown = true)
class ApiError(
        @JsonProperty("status") internal val status: Int = 0,
        @JsonProperty("title") internal val title: String? = "",
        @JsonProperty("details") internal val details: HashMap<String, Any>? = null
)