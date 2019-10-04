<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
    package="${configs.packageName}">
    
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application 
        android:allowBackup="true"
        android:label="@string/app_name"
        android:icon="${r"${appIcon}"}"
        android:roundIcon="${r"${appIconRound}"}"
        android:supportsRtl="true"
        android:theme="@style/AppTheme"
        android:name=".app.App"
        tools:ignore="GoogleAppIndexingWarning">

    	<activity
                android:name=".ui.splash.SplashActivity"
                android:screenOrientation="portrait">

            <intent-filter>

                <action android:name="android.intent.action.MAIN"/>

                <category android:name="android.intent.category.LAUNCHER"/>

            </intent-filter>

        </activity>
        
    </application>
    
</manifest>

