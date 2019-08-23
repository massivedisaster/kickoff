package ${configs.packageName}.data.common

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.Observer

class LiveDataWrapper<T> : MediatorLiveData<CallResult<T>>() {

    fun observeDatabase(owner: LifecycleOwner, observer: Observer<CallResult<T>>) {
        value?.connection?.database()
        observe(owner, observer)
    }

    fun observeNetwork(owner: LifecycleOwner, observer: Observer<CallResult<T>>) {
        value?.connection?.network()
        observe(owner, observer)
    }

    fun observeDbAndNetwork(owner: LifecycleOwner, observer: Observer<CallResult<T>>) {
        value?.connection?.dbAndNetwork()
        observe(owner, observer)
    }

}