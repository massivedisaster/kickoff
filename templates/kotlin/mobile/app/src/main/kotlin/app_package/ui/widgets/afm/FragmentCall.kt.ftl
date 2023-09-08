package ${configs.packageName}.ui.widgets.afm

import android.os.Bundle
import android.transition.TransitionInflater
import android.view.View
import androidx.annotation.IdRes
import androidx.fragment.app.Fragment
import ${configs.packageName}.ui.base.BaseActivity
import kotlin.reflect.KClass

class FragmentCall private constructor() : Builder() {

    enum class TransitionType {
        ADD, REPLACE
    }

    private val INVALID_CONTAINER_ID = -1

    private val ACTIVITY_NULL_EXCEPTION = "You must call init() before to define an activity to open a fragment"
    private val CLASS_NULL_EXCEPTION = "You must call setFragment to define a fragment to be called"

    private var activity: BaseActivity<*, *>? = null

    private var addToBackStack: Boolean = false
    private var bundle: Bundle? = null
    private var clazz: Class<out Fragment>? = null
    private var shareElementsMap: MutableMap<String, View> = mutableMapOf()

    private var transitionType: TransitionType = TransitionType.ADD

    @IdRes
    private var containerId = INVALID_CONTAINER_ID

    companion object {

        /**
         * Initializes builder setting up the activity that will hold the fragment
         *
         * @param activity
         * *
         * @return Builder instance
         */
        fun init(activity: BaseActivity<*, *>, clazz: KClass<out Fragment>): FragmentCall {
            val fragmentCall = FragmentCall()
            fragmentCall.init(activity, clazz)
            return fragmentCall
        }

        /**
         * Initializes builder setting up the activity that will hold the fragment
         *
         * @param activity
         * *
         * @return Builder instance
         */
        fun init(activity: BaseActivity<*, *>, frag: Fragment): FragmentCall {
            val fragmentCall = FragmentCall()
            fragmentCall.init(activity, frag)
            return fragmentCall
        }

    }

    /**
     * Initializes an instance of FragmentCall retrieving all necessary fields to add or replace
     * a fragment into an activity
     */
    private fun init(activity: BaseActivity<*, *>, clazz: KClass<out Fragment>) {
        this.activity = activity
        this.clazz = clazz.java
    }

    /**
     * Initializes an instance of FragmentCall retrieving all necessary fields to add or replace
     * a fragment into an activity
     */
    private fun init(activity: BaseActivity<*, *>, frag: Fragment) {
        this.activity = activity
        this.frag = frag
        setBundle(frag.arguments ?: Bundle.EMPTY)
        this.clazz = frag.javaClass
    }

    private lateinit var frag: Fragment

    override fun build() {
        validate()

        val fragmentManager = activity!!.supportFragmentManager
        val fragmentTransaction = fragmentManager.beginTransaction()

        containerId = if (containerId != INVALID_CONTAINER_ID) containerId else activity!!.containerId()

        for ((transactionName, view) in shareElementsMap) {
            fragmentTransaction.addSharedElement(view, transactionName)
        }

        try {
            val fragment = if(::frag.isInitialized) frag else clazz!!.newInstance()

            fragment.sharedElementEnterTransition = TransitionInflater.from(activity).inflateTransition(android.R.transition.move)
            fragment.sharedElementReturnTransition = TransitionInflater.from(activity).inflateTransition(android.R.transition.move)
            fragment.arguments = bundle

            val fragmentName = fragment.javaClass.name

            if (addToBackStack) {
                fragmentTransaction.addToBackStack(fragmentName)
            }

            if (transitionType == TransitionType.ADD) {
                fragmentTransaction.addToBackStack(if (addToBackStack) fragmentName else null)
                if (activity!!.supportFragmentManager.findFragmentById(containerId) != null) {
                    fragmentTransaction.hide(activity!!.supportFragmentManager.findFragmentById(containerId)!!)
                }

                fragmentTransaction.add(containerId, fragment, clazz?.simpleName)
            } else {
                fragmentTransaction.replace(containerId, fragment, clazz?.simpleName)
            }

            fragmentTransaction.commit()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        reset()
    }

    override fun validate() {
        if (activity == null) {
            throw NullPointerException(ACTIVITY_NULL_EXCEPTION)
        }

        if (clazz == null) {
            throw NullPointerException(CLASS_NULL_EXCEPTION)
        }
    }

    override fun reset() {
        activity = null
        addToBackStack = false
        bundle = null
        clazz = null
    }

    /**
     * Defines a container id to inflate the fragment
     *
     * @param containerId
     *
     * @return Builder instance
     */
    fun setContainerId(@IdRes containerId: Int): FragmentCall {
        this.containerId = containerId
        return this
    }

    /**
     * Defines bundle to be used by the opened fragment
     *
     * @param bundle arguments
     *
     * @return Builder instance
     */
    fun setBundle(bundle: Bundle): FragmentCall {
        this.bundle = bundle
        return this
    }

    /**
     * Define a flag to validate if adds the fragment to back stack or not
     *
     * @param addToBackStack
     *
     * @return Builder instance
     */
    fun addToBackStack(addToBackStack: Boolean): FragmentCall {
        this.addToBackStack = addToBackStack
        return this
    }

    /**
     * Transition type to be applied when instantiate the fragment
     * (It could be [.ADD] or [.REPLACE])
     *
     * @param transitionType [TransitionType]
     *
     * @return Builder instance
     */
    fun setTransitionType(transitionType: TransitionType): FragmentCall {
        this.transitionType = transitionType
        return this
    }

    fun addSharedElement(view: View, transactionName: String): FragmentCall {
        shareElementsMap[transactionName] = view
        return this
    }

}