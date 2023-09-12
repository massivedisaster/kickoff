package ${configs.packageName}.ui.base.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter

class PagerAdapter(
    fa: FragmentActivity,
    private val fragments: List<Fragment>
) : FragmentStateAdapter(fa) {

    override fun getItemCount() = fragments.size

    override fun createFragment(position: Int) = fragments[position]

}