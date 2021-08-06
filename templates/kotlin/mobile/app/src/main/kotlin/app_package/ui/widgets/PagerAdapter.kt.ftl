package ${configs.packageName}.ui.widgets

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter

class PagerAdapter(
        fragmentManager: FragmentManager,
        private val fragments: List<Fragment>,
        private val names: List<String>
) : FragmentStatePagerAdapter(fragmentManager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    /**
     * {@inheritDoc}
     */
    override fun getPageTitle(position: Int) = if (position >= fragments.size || position < 0) "" else names[position]

    /**
     * {@inheritDoc}
     */
    override fun getItem(position: Int) = fragments[position]

    /**
     * {@inheritDoc}
     */
    override fun getCount() = fragments.size

    fun updateScreens() {
        /*fragments.forEach { frag ->
            if (frag is SearchableFragment) {
                frag.search()
            }
        }*/
    }

}