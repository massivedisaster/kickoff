package ${configs.packageName}.ui.base.adapter.state

import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import com.google.android.material.button.MaterialButton

data class StateCardViews(
        val icon : AppCompatImageView? = null,
        val title : AppCompatTextView? = null,
        val body : AppCompatTextView? = null,
        val button : MaterialButton? = null
)