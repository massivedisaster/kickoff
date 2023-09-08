package ${configs.packageName}.ui.widgets.afm

abstract class Builder {

    /**
     * Build, call and finish the request
     */
    abstract fun build()

    /**
     * Validates if the builder is correctly filled
     */
    protected abstract fun validate()

    /**
     * Reset all values stored on last call
     */
    protected abstract fun reset()

}