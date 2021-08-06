package ${configs.packageName}.ui.widgets

import android.content.Context
import android.text.TextUtils
import android.util.AttributeSet
import android.view.Gravity
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import ${configs.packageName}.R
import ${configs.packageName}.utils.helper.extensions.dpInPx

class CenteredToolbar : Toolbar {

    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs)
    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(context, attrs, defStyleAttr)

    private var centeredTitleTextView: TextView? = null
    private var centeredLogoImageView: ImageView? = null

    override fun setLogo(@DrawableRes resId: Int) {
        getCenteredLogoImageView().setImageResource(resId)
    }

    override fun setTitle(@StringRes resId: Int) {
        val s = resources.getString(resId)
        title = s
    }

    override fun setTitle(title: CharSequence) {
        getCenteredTitleTextView().text = title
    }

    override fun getTitle() = getCenteredTitleTextView().text.toString()

    private fun getCenteredTitleTextView(): TextView {
        if (centeredTitleTextView == null) {
            centeredTitleTextView = TextView(context)
            centeredTitleTextView!!.setTextColor(ContextCompat.getColor(context, android.R.color.white))
            centeredTitleTextView!!.typeface = ResourcesCompat.getFont(context, R.font.roboto_bold)
            centeredTitleTextView!!.setSingleLine()
            centeredTitleTextView!!.ellipsize = TextUtils.TruncateAt.END
            centeredTitleTextView!!.gravity = Gravity.CENTER

            val lp = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
            lp.gravity = Gravity.CENTER
            centeredTitleTextView!!.layoutParams = lp

            addView(centeredTitleTextView)
        }
        return centeredTitleTextView!!
    }

    private fun getCenteredLogoImageView(): ImageView {
        if (centeredLogoImageView == null) {
            centeredLogoImageView = AspectRatioImageView(context)

            val lp = LayoutParams(150F.dpInPx(context).toInt(), LayoutParams.WRAP_CONTENT)
            lp.gravity = Gravity.CENTER
            centeredLogoImageView!!.layoutParams = lp

            addView(centeredLogoImageView)
        }
        return centeredLogoImageView!!
    }
}