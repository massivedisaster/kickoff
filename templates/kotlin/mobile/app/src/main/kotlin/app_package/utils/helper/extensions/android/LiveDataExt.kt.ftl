package ${configs.packageName}.utils.helper.extensions.android

import androidx.lifecycle.MutableLiveData

fun <T> MutableLiveData<T>.addValue(newValue: T) {
    if (value != newValue) {
        value = newValue
    }
}