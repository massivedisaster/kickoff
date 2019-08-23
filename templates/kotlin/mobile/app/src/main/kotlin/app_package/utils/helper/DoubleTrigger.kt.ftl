package ${configs.packageName}.utils

/*import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData

class DoubleTrigger<ReturnType, InputA, InputB>(a: LiveData<InputA>, b: LiveData<InputB>, repository: Repository) : MediatorLiveData<ReturnType>() {

    private var category = 0L

    init {
        addSource(a) {
            category = it
            value = repository.get(it)
        }
        addSource(b) { value = repository.get(null) }
    }
}*/