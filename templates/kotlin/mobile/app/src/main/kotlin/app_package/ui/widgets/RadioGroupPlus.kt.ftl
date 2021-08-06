package ${configs.packageName}.ui.widgets

import android.content.Context
import android.content.res.TypedArray
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.CompoundButton
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import androidx.annotation.IdRes

/**
 * This class is used to create a multiple-exclusion scope for a set of radio
 * buttons. Checking one radio button that belongs to a radio group unchecks
 * any previously checked radio button within the same group.
 *
 * Intially, all of the radio buttons are unchecked. While it is not possible
 * to uncheck a particular radio button, the radio group can be cleared to
 * remove the checked state.
 *
 * The selection is identified by the unique id of the radio button as defined
 * in the XML layout file.
 *
 * **XML Attributes**
 *
 * See [RadioGroup Attributes][com.android.internal.R.styleable.RadioGroup],
 * [LinearLayout Attributes][com.android.internal.R.styleable.LinearLayout],
 * [ViewGroup Attributes][com.android.internal.R.styleable.ViewGroup],
 * [View Attributes][com.android.internal.R.styleable.View]
 *
 * Also see
 * [LinearLayout.LayoutParams][android.widget.LinearLayout.LayoutParams]
 * for layout attributes.
 *
 * @see RadioButton
 */
class RadioGroupPlus : LinearLayout {
    // holds the checked id; the selection is empty by default
    /**
     * Returns the identifier of the selected radio button in this group.
     * Upon empty selection, the returned value is -1.
     *
     * @return the unique id of the selected radio button in this group
     * @attr ref android.R.styleable#RadioGroup_checkedButton
     * @see .check
     * @see .clearCheck
     */
    @get:IdRes
    var checkedRadioButtonId = -1
        private set
    // tracks children radio buttons checked state
    private var childOnCheckedChangeListener: CompoundButton.OnCheckedChangeListener? = null
    // when true, onCheckedChangeListener discards events
    private var protectFromCheckedChange = false
    internal var onCheckedChangeListener: OnCheckedChangeListener? = null
    private var passThroughListener: PassThroughHierarchyChangeListener? = null

    private var lastAttributedId: Int = 1

    fun resetIds() {
        lastAttributedId = 1
    }
    /**
     * {@inheritDoc}
     */
    constructor(context: Context) : super(context) {
        orientation = VERTICAL
        init()
    }

    /**
     * {@inheritDoc}
     */
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        init()
    }

    private fun init() {
        childOnCheckedChangeListener = CheckedStateTracker()
        passThroughListener = PassThroughHierarchyChangeListener()
        super.setOnHierarchyChangeListener(passThroughListener)
    }

    /**
     * {@inheritDoc}
     */
    override fun setOnHierarchyChangeListener(listener: OnHierarchyChangeListener) {
        // the user listener is delegated to our pass-through listener
        passThroughListener!!.mOnHierarchyChangeListener = listener
    }

    /**
     * {@inheritDoc}
     */
    override fun onFinishInflate() {
        super.onFinishInflate()

        // checks the appropriate radio button as requested in the XML file
        if (checkedRadioButtonId != -1) {
            protectFromCheckedChange = true
            setCheckedStateForView(checkedRadioButtonId, true)
            protectFromCheckedChange = false
            setCheckedId(checkedRadioButtonId)
        }
    }

    override fun addView(child: View, index: Int, params: ViewGroup.LayoutParams) {
        if (child is ViewGroup) {
            val childCount = child.childCount
            for (i in 0..childCount) {
                val element = child.getChildAt(i)
                find(element)
            }
        }

        super.addView(child, index, params)
        init()
    }

    private fun find(view: View?) {
        if (view is ViewGroup) {
            val childCount = view.childCount
            for (i in 0..childCount) {
                val element = view.getChildAt(i)
                find(element)
            }
        }
        if (view is RadioButton && view.isChecked) {
            protectFromCheckedChange = true
            if (checkedRadioButtonId != -1) {
                setCheckedStateForView(checkedRadioButtonId, false)
            }
            protectFromCheckedChange = false
            setCheckedId(view.id)
        }
    }

    /**
     * Sets the selection to the radio button whose identifier is passed in
     * parameter. Using -1 as the selection identifier clears the selection;
     * such an operation is equivalent to invoking [.clearCheck].
     *
     * @param id the unique id of the radio button to select in this group
     * @see .getCheckedRadioButtonId
     * @see .clearCheck
     */
    fun check(@IdRes id: Int) {
        // don't even bother
        if (id != -1 && id == checkedRadioButtonId) {
            return
        }

        if (checkedRadioButtonId != -1) {
            setCheckedStateForView(checkedRadioButtonId, false)
        }

        if (id != -1) {
            setCheckedStateForView(id, true)
        }

        setCheckedId(id)
    }

    private fun setCheckedId(@IdRes id: Int) {
        checkedRadioButtonId = id
        if (onCheckedChangeListener != null) {
            onCheckedChangeListener!!.onCheckedChanged(this, checkedRadioButtonId)
        }
    }

    private fun setCheckedStateForView(viewId: Int, checked: Boolean) {
        val checkedView = findViewById<View>(viewId)
        if (checkedView != null && checkedView is RadioButton) {
            checkedView.isChecked = checked
        }
    }

    /**
     * Clears the selection. When the selection is cleared, no radio button
     * in this group is selected and [.getCheckedRadioButtonId] returns
     * null.
     *
     * @see .check
     * @see .getCheckedRadioButtonId
     */
    fun clearCheck() {
        check(-1)
    }

    /**
     * {@inheritDoc}
     */
    override fun generateLayoutParams(attrs: AttributeSet) = LayoutParams(context, attrs)

    /**
     * {@inheritDoc}
     */
    override fun checkLayoutParams(p: ViewGroup.LayoutParams) = p is RadioGroup.LayoutParams

    override fun generateDefaultLayoutParams() = LayoutParams(WRAP_CONTENT, WRAP_CONTENT)

    override fun getAccessibilityClassName() = RadioGroup::class.java.name

    /**
     * This set of layout parameters defaults the width and the height of
     * the children to [.WRAP_CONTENT] when they are not specified in the
     * XML file. Otherwise, this class ussed the value read from the XML file.
     *
     * See
     * [LinearLayout Attributes][com.android.internal.R.styleable.LinearLayout_Layout]
     * for a list of all child view attributes that this class supports.
     */
    class LayoutParams : LinearLayout.LayoutParams {
        /**
         * {@inheritDoc}
         */
        constructor(c: Context, attrs: AttributeSet) : super(c, attrs)

        /**
         * {@inheritDoc}
         */
        constructor(w: Int, h: Int) : super(w, h)

        /**
         * {@inheritDoc}
         */
        constructor(w: Int, h: Int, initWeight: Float) : super(w, h, initWeight)

        /**
         * {@inheritDoc}
         */
        constructor(p: ViewGroup.LayoutParams) : super(p)

        /**
         * {@inheritDoc}
         */
        constructor(source: ViewGroup.MarginLayoutParams) : super(source)

        /**
         *
         * Fixes the child's width to
         * [android.view.ViewGroup.LayoutParams.WRAP_CONTENT] and the child's
         * height to  [android.view.ViewGroup.LayoutParams.WRAP_CONTENT]
         * when not specified in the XML file.
         *
         * @param a          the styled attributes set
         * @param widthAttr  the width attribute to fetch
         * @param heightAttr the height attribute to fetch
         */
        override fun setBaseAttributes(a: TypedArray, widthAttr: Int, heightAttr: Int) {

            width = if (a.hasValue(widthAttr)) {
                a.getLayoutDimension(widthAttr, "layout_width")
            } else {
                ViewGroup.LayoutParams.WRAP_CONTENT
            }

            height = if (a.hasValue(heightAttr)) {
                a.getLayoutDimension(heightAttr, "layout_height")
            } else {
                ViewGroup.LayoutParams.WRAP_CONTENT
            }
        }
    }

    /**
     *
     * Interface definition for a callback to be invoked when the checked
     * radio button changed in this group.
     */
    interface OnCheckedChangeListener {
        /**
         *
         * Called when the checked radio button has changed. When the
         * selection is cleared, checkedId is -1.
         *
         * @param group     the group in which the checked radio button has changed
         * @param checkedId the unique identifier of the newly checked radio button
         */
        fun onCheckedChanged(group: RadioGroupPlus, @IdRes checkedId: Int)
    }

    private inner class CheckedStateTracker : CompoundButton.OnCheckedChangeListener {
        override fun onCheckedChanged(buttonView: CompoundButton, isChecked: Boolean) {
            // prevents from infinite recursion
            if (protectFromCheckedChange) {
                return
            }

            protectFromCheckedChange = true
            if (checkedRadioButtonId != -1) {
                setCheckedStateForView(checkedRadioButtonId, false)
            }
            protectFromCheckedChange = false

            val id = buttonView.id
            if (isChecked) {
                setCheckedId(id)
            }
        }
    }

    /**
     *
     * A pass-through listener acts upon the events and dispatches them
     * to another listener. This allows the table layout to set its own internal
     * hierarchy change listener without preventing the user to setup his.
     */
    private inner class PassThroughHierarchyChangeListener : OnHierarchyChangeListener {
        internal var mOnHierarchyChangeListener: OnHierarchyChangeListener? = null

        fun traverseTree(view: View) {
            if (view is RadioButton) {
                var id = view.getId()
                // generates an id if it's missing
                if (id == View.NO_ID) {
                    id = View.generateViewId()
                    view.setId(lastAttributedId)
                    lastAttributedId++
                }
                view.setOnCheckedChangeListener(childOnCheckedChangeListener)
            }
            if (view !is ViewGroup) {
                return
            }
            if (view.childCount == 0) {
                return
            }
            for (i in 0 until view.childCount) {
                traverseTree(view.getChildAt(i))
            }
        }

        /**
         * {@inheritDoc}
         */
        override fun onChildViewAdded(parent: View, child: View) {
            traverseTree(child)
            if (parent === this@RadioGroupPlus && child is RadioButton) {
                var id = child.getId()
                // generates an id if it's missing
                if (id == View.NO_ID) {
                    id = View.generateViewId()
                    child.setId(id)
                }
                child.setOnCheckedChangeListener(childOnCheckedChangeListener)
            }

            mOnHierarchyChangeListener?.onChildViewAdded(parent, child)
        }

        /**
         * {@inheritDoc}
         */
        override fun onChildViewRemoved(parent: View, child: View) {
            if (parent === this@RadioGroupPlus && child is RadioButton) {
                child.setOnCheckedChangeListener(null)
            }

            mOnHierarchyChangeListener?.onChildViewRemoved(parent, child)
        }
    }
}