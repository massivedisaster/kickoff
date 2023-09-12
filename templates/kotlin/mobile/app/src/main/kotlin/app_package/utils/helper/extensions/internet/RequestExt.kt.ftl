@file:Suppress("UNUSED_EXPRESSION")

package ${configs.packageName}.utils.helper.extensions.internet

import okhttp3.RequestBody
import okio.Buffer
import java.io.IOException

fun RequestBody?.bodyToString() = try {
    val copy = this
    val buffer = Buffer()
    if (copy != null) copy.writeTo(buffer) else ""
    buffer.readUtf8()
} catch (e: IOException) { "" }