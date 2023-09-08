package ${configs.packageName}.ui.widgets.afm

/**
 * OnBackPressedListener Interface.
 * Implement this interface in fragments to get back pressed events from activity.
 */
interface OnBackPressedListener {
    /**
     * Used to check if the active fragment wants to consume the back press.
     *
     * @return false if the fragment wants the activity to call super.onBackPressed, otherwise nothing will happen.
     */
    fun onBackPressed(): Boolean
}