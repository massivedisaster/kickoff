package ${configs.packageName}.utils.live_data_bus


/*
 * Copyright (C) 2018 ductranit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import androidx.annotation.NonNull
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.Observer

/**
 * Singleton object to manage bus events.
 */
object LiveDataBus {

    private val subjectMap = HashMap<String, EventLiveData>()

    /**
     * Get the live data or create it if it's not already in memory.
     */
    @NonNull
    private fun getGlobalLiveData(subjectCode: String): List<EventLiveData> {
        val result = mutableListOf<EventLiveData>()
        subjectMap.forEach {entry ->
            if(entry.key.startsWith(subjectCode)) {
                var liveData: EventLiveData? = entry.value
                if (liveData != null) {
                    result.add(liveData)
                }
            }
        }
        return result
    }

    /**
     * Get the live data or create it if it's not already in memory.
     */
    @NonNull
    private fun getLiveData(subjectCode: String): EventLiveData {
        var liveData = subjectMap[subjectCode]
        if (liveData == null) {
            liveData = EventLiveData(subjectCode)
            subjectMap[subjectCode] = liveData
        }

        return liveData
    }

    /**
     * Subscribe to the specified subject and listen for updates on that subject.
     * If you have several instances with the same name
     * ex: you reuse the same fragment several times within one activity
     * you might want to send your subject as it is (the used identifier) followed by a unique ID
     */
    fun subscribe(subject: String, uniqueID : String = "", @NonNull lifecycle: LifecycleOwner, @NonNull action: Observer<ListConsumableEvent>) {
        try {
            // avoid register same instance
            getLiveData(subject + lifecycle::class.java.name + uniqueID).observe(lifecycle, action)
        } catch (throwable: IllegalArgumentException) {
            throwable.printStackTrace()
        }
    }

    /**
     * Removes this subject when it has no observers.
     */
    fun unregister(subject: String) {
        subjectMap.remove(subject)
    }

    /**
     * Publish an object to the specified subject for all subscribers of that subject.
     */
    fun publish(subject: String, message: ConsumableEvent = ConsumableEvent()) {
        getGlobalLiveData(subject).forEach {
            it.update(message.copy())
        }
    }
}