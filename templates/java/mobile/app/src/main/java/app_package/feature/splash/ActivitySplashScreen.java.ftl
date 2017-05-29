package ${configs.packageName}.feature.splash;

import ${configs.packageName}.base.activity.ActivityFullScreen;
import com.massivedisaster.activitymanager.ActivityFragmentManager;

/**
 * Activity to apply the splash screen.
 */
public class ActivitySplashScreen extends ActivityFullScreen {

    @Override
    protected void onStart() {
        super.onStart();

        if (getSupportFragmentManager().getBackStackEntryCount() == 0 && !getIntent().hasExtra(ActivityFragmentManager.ACTIVITY_MANAGER_FRAGMENT)) {
            performTransaction(new FragmentSplashScreen(), FragmentSplashScreen.class.getCanonicalName());
        }
    }
}
