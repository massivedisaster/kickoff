package ${configs.packageName}.ui.widgets

import android.content.Context
import android.graphics.PorterDuff
import android.text.InputFilter
import android.text.InputType
import android.text.method.PasswordTransformationMethod
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.core.content.res.ResourcesCompat
import com.google.android.material.textfield.TextInputLayout.END_ICON_NONE
import ${configs.packageName}.R
import ${configs.packageName}.databinding.ViewInputBinding
import ${configs.packageName}.utils.helper.extensions.setupFocusKeyboard


class InputLayout : FrameLayout {

    lateinit var dataBinding: ViewInputBinding

    var text: String?
        get() = dataBinding.editText.text?.toString()
        set(value) { dataBinding.editText.setText(value) }

    var suffixText: String?
        get() = dataBinding.inputLayout.suffixText?.toString()
        set(value) { dataBinding.inputLayout.suffixText = value }

    var prefixText: String?
        get() = dataBinding.inputLayout.prefixText?.toString()
        set(value) { dataBinding.inputLayout.prefixText = value }

    constructor(context: Context) : super(context) { initLayout(null) }
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) { initLayout(attrs) }
    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle) { initLayout(attrs) }

    private fun initLayout(attrs: AttributeSet?) {
        val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        dataBinding = ViewInputBinding.inflate(inflater, this, true)

        dataBinding.inputLayout.isHintEnabled = false
        dataBinding.inputLayout.isErrorEnabled = false
        dataBinding.editText.setupFocusKeyboard()

        attrs?.let { attributes ->
            val typedArray = context.obtainStyledAttributes(attributes, R.styleable.InputLayout, 0, 0)

            val hint = typedArray.getText(R.styleable.InputLayout_hint)
            hint?.let {
                dataBinding.editText.hint = it
            }

            val suffix = typedArray.getText(R.styleable.InputLayout_suffixText)
            suffix?.let {
                suffixText = it.toString()
            }
            val prefix = typedArray.getText(R.styleable.InputLayout_prefixText)
            prefix?.let {
                prefixText = it.toString()
            }

            dataBinding.inputLayout.startIconDrawable = typedArray.getDrawable(R.styleable.InputLayout_startIcDrawable)
            dataBinding.inputLayout.setStartIconTintList(typedArray.getColorStateList(R.styleable.InputLayout_startIcTint))
            dataBinding.inputLayout.setStartIconTintMode(parseTintMode(typedArray.getInt(R.styleable.InputLayout_startIcTintMode, -1)))

            val inputType = typedArray.getInt(R.styleable.InputLayout_inputType, InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_MULTI_LINE)
            dataBinding.editText.inputType = inputType

            val maxLength = typedArray.getInt(R.styleable.InputLayout_maxLength, -1)
            if (maxLength > 0) {
                dataBinding.editText.filters = arrayOf(InputFilter.LengthFilter(maxLength))
            }

            val imeOptions = typedArray.getInt(R.styleable.InputLayout_imeOptions, EditorInfo.IME_NULL)
            dataBinding.editText.imeOptions = imeOptions

            val lines = typedArray.getInt(R.styleable.InputLayout_lines, 1)
            dataBinding.editText.setLines(lines)
            dataBinding.editText.maxLines = lines

            val gravity = typedArray.getInt(R.styleable.InputLayout_gravity, Gravity.TOP or Gravity.START)
            dataBinding.editText.gravity = gravity

            if (inputType == 129) { // 129 is not mapped in Google InputType enum...
                dataBinding.editText.typeface = ResourcesCompat.getFont(this.context, R.font.roboto)
                dataBinding.editText.transformationMethod = PasswordTransformationMethod()
            }

            dataBinding.inputLayout.endIconMode = END_ICON_NONE

            typedArray.recycle()
        }
    }

    private fun parseTintMode(value: Int) = when (value) {
        3 -> PorterDuff.Mode.SRC_OVER
        5 -> PorterDuff.Mode.SRC_IN
        9 -> PorterDuff.Mode.SRC_ATOP
        14 -> PorterDuff.Mode.MULTIPLY
        15 -> PorterDuff.Mode.SCREEN
        16 -> PorterDuff.Mode.ADD
        else -> PorterDuff.Mode.SRC_ATOP
    }

}