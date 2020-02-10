package ${configs.packageName}.utils.manager

import android.content.Context
import android.content.SharedPreferences
import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PreferencesManager @Inject constructor(context: Context) {

    companion object {
        const val FIRST_TIME = "FIRST_TIME"
        const val FIRST_LOGIN = "FIRST_LOGIN"
<#if configs.hasOneSignal!true>
        const val PUSH_ID = "PUSH_ID"
</#if>
        const val KEY = "VALUE"

        inline fun <reified T : Any> getObject(json: String?): T? {
            val mapper = jacksonObjectMapper()
            try {
                if (json.isNullOrBlank()) return null
                return mapper.readValue(json)
            } catch (e: IOException) {
                e.printStackTrace()
            }
            return null
        }

        fun getJson(`object`: Any?): String? {
            val mapper = jacksonObjectMapper()
            try {
                if (`object` == null) return null
                return mapper.writeValueAsString(`object`)
            } catch (e: JsonProcessingException) {
                e.printStackTrace()
            }

            return null
        }
    }

    val prefs: SharedPreferences = context.getSharedPreferences("${configs.packageName}", Context.MODE_PRIVATE)

    var firstRun: Boolean
        get() = read(FIRST_TIME, true)!!
        set(value) = write(FIRST_TIME, value)

    var firstLogin: Boolean
        get() = read(FIRST_LOGIN, true)!!
        set(value) = write(FIRST_LOGIN, value)

    fun edit(task: (SharedPreferences.Editor) -> Unit) {
        val editor = prefs.edit()
        task(editor)
        editor.apply()
    }

    fun write(key: String, value: Any) {
        when (value) {
            is String -> edit { it.putString(key, value) }
            is Int -> edit { it.putInt(key, value) }
            is Boolean -> edit { it.putBoolean(key, value) }
            is Float -> edit { it.putFloat(key, value) }
            is Long -> edit { it.putLong(key, value) }
            else -> edit { it.putString(key, getJson(value)) }
        }
    }

    inline fun <reified T : Any> read(key: String, defaultValue: T? = null): T? = when (defaultValue) {
            is String -> prefs.getString(key, defaultValue as? String) as T
            is Int -> prefs.getInt(key, defaultValue as? Int ?: -1) as T
            is Boolean -> prefs.getBoolean(key, defaultValue as? Boolean ?: false) as T
            is Float -> prefs.getFloat(key, defaultValue as? Float ?: -1f) as T
            is Long -> prefs.getLong(key, defaultValue as? Long ?: -1) as T
            else -> getObject(prefs.getString(key, ""))
        }

    fun remove(key: String) {
        if (prefs.contains(key)) {
            edit { it.remove(key) }
        }
    }

    fun deleteAll() {
        edit { it.clear() }
    }

}