package ${configs.packageName}.base.activity;

import ${configs.packageName}.R;

import com.massivedisaster.activitymanager.AbstractFragmentActivity;

/**
 * This activity is fullscreen.
 * The fragments opened, added or replaced will go to fit all the activity.
 */
public class ActivityFullScreen extends AbstractFragmentActivity {
    @Override
    protected int getLayoutResId() {
        return R.layout.activity_fullscreen;
    }

    @Override
    protected int getContainerViewId() {
        return R.id.frmContainer;
    }
}
