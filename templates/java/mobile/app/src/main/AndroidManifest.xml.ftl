<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="${configs.packageName}">
    
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application 
        android:allowBackup="true"
        android:label="@string/app_name"
        android:icon="${r"${appIcon}"}"
        android:theme="@style/Base.Theme.AppCompat.Light.DarkActionBar"
        android:name=".app.App">

    	<activity
            android:name=".feature.splash.ActivitySplashScreen"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>

                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <#if configs.dependencies.fabrickey??>
        <meta-data
            android:name="io.fabric.ApiKey"
            android:value="${configs.dependencies.fabrickey}" />
		</#if>

    </application>
</manifest>

