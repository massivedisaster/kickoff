package ${configs.packageName}.utils.live_data_bus

data class ListConsumableEvent(val list : MutableList<ConsumableEvent>) {

    /**
     *  run task & consume event after that
     */
    fun runAndClear(runnable: (MutableList<ConsumableEvent>) -> Unit) {
        runnable(list)
        list.forEach {
            if (!it.isConsumed) {
                it.isConsumed = true
            }
        }
    }

}