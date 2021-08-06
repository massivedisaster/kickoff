package ${configs.packageName}.ui.base

import android.content.Context
import ${configs.packageName}.R
import ${configs.packageName}.ui.base.adapter.GenericStateCardErrorViews
import ${configs.packageName}.utils.helper.extensions.removeView
import ${configs.packageName}.utils.helper.extensions.showView

fun BigNoInternetErrors(ctx: Context, view: GenericStateCardErrorViews) {
    view.icon?.removeView()
//    view.icon?.apply {
//        setImageResource(R.drawable.ic_erro_servico)
//        showView()
//    }

    view.title?.apply {
//        text = ctx.getString(R.string.generic_internet_connection_error_title)
        showView()
    }

    view.body?.apply {
//        text = ctx.getString(R.string.generic_internet_connection_error_body)
        showView()
    }

    view.button?.apply {
        text = ctx.getString(R.string.btn_retry)
        showView()
    }
}

fun SmallNoInternetErrors(ctx: Context, view: GenericStateCardErrorViews) {
    view.icon?.removeView()

    view.title?.apply {
//        text = ctx.getString(R.string.generic_internet_connection_error_title)
        showView()
    }

    view.body?.apply {
//        text = ctx.getString(R.string.generic_internet_connection_error_body)
        showView()
    }

    view.button?.apply {
        text = ctx.getString(R.string.btn_retry)
        showView()
    }
}

fun BigGenericOtherErrors(ctx: Context, view: GenericStateCardErrorViews) {
    view.icon?.removeView()
//    view.icon?.apply {
//        setImageResource(R.drawable.ic_erro_servico)
//        showView()
//    }

    view.title?.removeView()

    view.body?.apply {
        text = ctx.getString(R.string.generic_error_retry_text)
        showView()
    }

    view.button?.apply {
        text = ctx.getString(R.string.btn_retry)
        showView()
    }
}

fun SmallGenericOtherErrors(ctx: Context, view: GenericStateCardErrorViews) {
    view.icon?.removeView()

    view.title?.removeView()

    view.body?.apply {
        text = ctx.getString(R.string.generic_error_retry_text)
        showView()
    }

    view.button?.apply {
        text = ctx.getString(R.string.btn_retry)
        showView()
    }
}

//in case you want to reuse some specific error view pattern but need to have
//different sizes based on screen
//you should create a function and pass this param
enum class BigSize {
    BIG, MEDIUM, SMALL
}




