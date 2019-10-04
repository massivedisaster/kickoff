package ${configs.packageName}.ui.animation

import androidx.annotation.IntDef

@Retention(AnnotationRetention.SOURCE)
@IntDef(Animations.NONE, Animations.LEFT_IN, Animations.RIGHT_IN, Animations.UP_IN,
        Animations.DOWN_IN, Animations.LEFT_OUT, Animations.RIGHT_OUT, Animations.UP_OUT,
        Animations.DOWN_OUT, Animations.LEFT, Animations.RIGHT, Animations.UP, Animations.DOWN)
annotation class AnimationType

object Animations {
    const val NONE = 0
    const val LEFT_IN = 1
    const val RIGHT_IN = 2
    const val UP_IN = 3
    const val DOWN_IN = 4
    const val LEFT_OUT = 5
    const val RIGHT_OUT = 6
    const val UP_OUT = 7
    const val DOWN_OUT = 8
    const val LEFT = 9
    const val RIGHT = 10
    const val UP = 11
    const val DOWN = 12
}
