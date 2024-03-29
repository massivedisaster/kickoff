<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools">
    
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission
        android:name="android.permission.AUTHENTICATE_ACCOUNTS"
        android:maxSdkVersion="22" />
    <uses-permission
        android:name="android.permission.GET_ACCOUNTS"
        android:maxSdkVersion="22" />
    <uses-permission
        android:name="android.permission.MANAGE_ACCOUNTS"
        android:maxSdkVersion="22" />

    <!-- Permission to use BiometricPrompt -->
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />

    <application 
        android:name=".app.App"
        android:allowBackup="false"
        android:label="@string/app_name"
        android:icon="${r"${appIcon}"}"
        android:roundIcon="${r"${appIconRound}"}"
        android:supportsRtl="true"
        android:allowClearUserData="true"
        android:theme="@style/AppTheme.NoActionBar"
        tools:ignore="GoogleAppIndexingWarning">

    	<activity
            android:name=".ui.screens.splash.SplashActivity"
            android:exported="true"
            android:screenOrientation="portrait"
            tools:ignore="LockedOrientationActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <service
            android:name=".utils.authentication.AuthenticationService"
            android:exported="false"
            android:process=":auth">
            <intent-filter>
                <action android:name="android.accounts.AccountAuthenticator" />
            </intent-filter>

            <meta-data
                android:name="android.accounts.AccountAuthenticator"
                android:resource="@xml/authenticator" />
        </service>

    </application>
    
</manifest>

