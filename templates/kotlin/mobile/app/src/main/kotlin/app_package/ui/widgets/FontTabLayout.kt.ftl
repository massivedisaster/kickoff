package ${configs.packageName}.ui.widgets

import android.content.Context
import android.graphics.Typeface
import android.util.AttributeSet
import android.view.ViewGroup
import android.widget.TextView
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.tabs.TabLayout
import ${configs.packageName}.R

class FontTabLayout : TabLayout {
    private var typeface: Typeface? = null
    private var typefaceSelected: Typeface? = null

    constructor(context: Context) : super(context) {
        init()
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        init()
    }

    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle) {
        init()
    }

    private fun init() {
        typeface = ResourcesCompat.getFont(context, R.font.roboto)
        typefaceSelected = ResourcesCompat.getFont(context, R.font.roboto)

        addOnTabSelectedListener(object : OnTabSelectedListener {
            override fun onTabSelected(tab: Tab) {
                val mainView = getChildAt(0) as ViewGroup
                val tabView = mainView.getChildAt(tab.position) as ViewGroup
                setFont(tabView, typefaceSelected)
            }

            override fun onTabUnselected(tab: Tab) {
                val mainView = getChildAt(0) as ViewGroup
                val tabView = mainView.getChildAt(tab.position) as ViewGroup
                setFont(tabView, typeface)
            }

            override fun onTabReselected(tab: Tab) {

            }
        })
    }

    override fun addTab(tab: Tab, position: Int, setSelected: Boolean) {
        super.addTab(tab, position, setSelected)

        val mainView = getChildAt(0) as ViewGroup
        val tabView = mainView.getChildAt(tab.position) as ViewGroup

        setFont(tabView, typefaceSelected)
        tabView.post {
            if (position > 0) {
                setFont(tabView, typeface)
            }
        }
    }

    private fun setFont(tabView: ViewGroup, font: Typeface?) {
        val tabChildCount = tabView.childCount
        for (i in 0 until tabChildCount) {
            val tabViewChild = tabView.getChildAt(i)
            if (tabViewChild is TextView) {
                tabViewChild.typeface = font
            }
        }
    }
}