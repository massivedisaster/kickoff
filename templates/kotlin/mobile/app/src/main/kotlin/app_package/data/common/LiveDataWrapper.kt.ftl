package ${configs.packageName}.data.common

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.Observer

class LiveDataWrapper<T> : MediatorLiveData<CallResult<T>>() {

    fun observeDatabase(owner: LifecycleOwner, observer: Observer<CallResult<T>>) {
        value?.connection?.database()
        observe(owner, observer)
    }

    fun observeNetwork(owner: LifecycleOwner, observer: Observer<CallResult<T>>, initCall : Boolean = true) : NetworkBoundResource<T,*,*>? {
        val network = value?.connection
        if(initCall) {
            network?.network()
        }
        observe(owner, observer)
        return network
    }

    fun observeDbAndNetwork(owner: LifecycleOwner, observer: Observer<CallResult<T>>, initCall : Boolean = true) : NetworkBoundResource<T,*,*>? {
        val network = value?.connection
        if(initCall) {
            network?.dbAndNetwork()
        }
        observe(owner, observer)
        return network
    }

    fun observeNetworkForever(observer: Observer<CallResult<T>>, initCall : Boolean = true) : NetworkBoundResource<T,*,*>? {
        val network = value?.connection
        if(initCall) {
            network?.network()
        }
        observeForever(observer)
        return network
    }

}