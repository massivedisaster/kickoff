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

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer

/**
 * A custom LiveData which can unregister when there is no observer
 */
class EventLiveData(private val subject: String, private val list : MutableList<ConsumableEvent> = mutableListOf()) : MutableLiveData<ListConsumableEvent>() {

    fun update(obj: ConsumableEvent) {
        list.removeAll { it.isConsumed }
        if(obj.consumableID.isNotEmpty()){
            if(!list.any { it.consumableID == obj.consumableID }) {
                list.add(obj)
            } else {
                list[list.indexOfFirst { it.consumableID == obj.consumableID }] = obj
            }
        }

        postValue(ListConsumableEvent(list))
    }

    override fun removeObserver(observer: Observer<in ListConsumableEvent>) {
        super.removeObserver(observer)
        if (!hasObservers()) {
            LiveDataBus.unregister(subject)
        }
    }
}