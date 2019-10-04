package ${configs.packageName}.ui.animation

import androidx.annotation.AnimRes

interface TransactionAnimation {
/**
* Gets the entering animation.
* @return the animation.
*/
@get:AnimRes
val animationEnter: Int

/**
* Gets the exiting animation.
* @return the animation.
*/
@get:AnimRes
val animationExit: Int

/**
* Gets the pop entering animation.
* @return the animation.
*/
@get:AnimRes
val animationPopEnter: Int

/**
* Gets the pop exiting animation.
* @return the animation.
*/
@get:AnimRes
val animationPopExit: Int
}