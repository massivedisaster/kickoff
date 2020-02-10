<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
    package="${configs.packageName}">
    
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

    <application 
        android:allowBackup="false"
        android:label="@string/app_name"
        android:icon="${r"${appIcon}"}"
        android:roundIcon="${r"${appIconRound}"}"
        android:supportsRtl="true"
        android:theme="@style/AppTheme.NoActionBar"
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

        <service
                android:name="com.massivedisaster.adal.account.AuthenticationService"
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

