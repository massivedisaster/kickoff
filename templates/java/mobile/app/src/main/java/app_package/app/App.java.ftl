package ${configs.packageName}.app;

import android.app.Application;

<#if configs.fabrickey??>
import ${configs.packageName}.BuildConfig;

import com.crashlytics.android.Crashlytics;

import io.fabric.sdk.android.Fabric;
</#if>
<#if configs.onesignal??>
import com.onesignal.OneSignal;
</#if>

/**
 * Base class fot the application.
 * You need to add this class to your manifest file.
 */
public class App extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
		<#if configs.fabrickey??>

        if (BuildConfig.CRASHLYTICS_ENABLED) {
            Fabric.with(this, new Crashlytics());
        }
		</#if>
		<#if configs.onesignal??>

        OneSignal.startInit(this).init();
		</#if>
    }
}
