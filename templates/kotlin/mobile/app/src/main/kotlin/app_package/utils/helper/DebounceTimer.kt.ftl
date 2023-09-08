package ${configs.packageName}.utils.helper

import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import java.util.*

class DebounceTimer(private val lifecycle: Lifecycle
                    , private var timerFirst: Timer = Timer()
                    , private var timerLast: Timer = Timer()) : LifecycleObserver {

    companion object {
        const val DEFAULT_DELAY = 750L
    }

    init {
        lifecycle.addObserver(this)
    }

    private var canRun = true
    fun debounceRunFirst(milWait: Long = DEFAULT_DELAY, block: () -> Unit) {
        if(canRun) {
            canRun = false
            block.invoke()
            timerLast.cancel()
            timerLast = Timer()
            timerLast.schedule(
                    object : TimerTask() {
                        override fun run() {
                            canRun = true
                        }
                    },
                    milWait
            )
        } else {
            Log.w(javaClass.simpleName , "Block was debounced!")
        }
    }

    fun debounceRunLast(milWait: Long = DEFAULT_DELAY, block: () -> Unit) {
        timerFirst.cancel()
        timerFirst = Timer()
        timerFirst.schedule(
                object : TimerTask() {
                    override fun run() {
                        block.invoke()
                    }
                },
                milWait
        )
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun destroy() {
        timerFirst.cancel()
        timerLast.cancel()
        lifecycle.removeObserver(this)
    }
}