<#if configs.hasOneSignal!true>
apply plugin: 'com.onesignal.androidsdk.onesignal-gradle-plugin'
</#if>
apply plugin: 'com.android.application'
apply from: "$project.rootDir/tools/git-version.gradle"
apply from: "$project.rootDir/tools/versions.gradle"
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-kapt'
apply plugin: 'kotlin-android-extensions'

android {
    compileSdkVersion versions.compileSdk

    defaultConfig {
        applicationId "${configs.packageName}"
        minSdkVersion versions.minSdk
        targetSdkVersion versions.targetSdk
        <#if configs.network??>
        buildConfigField ("long", "API_TIMEOUT", "${configs.network.timeout}")
        </#if>
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    buildFeatures {
        dataBinding = true
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    packagingOptions {
        exclude 'LICENSE.txt'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/ASL2.0'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/NOTICE'
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    buildTypes {
        prod {
            initWith release
            debuggable false
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), "$project.rootDir/tools/rules-proguard.pro"
            manifestPlaceholders += [
                appIcon: "@mipmap/ic_launcher",
                appIconRound: "@mipmap/ic_launcher_round"
            ]
        }

        <#if configs.hasQa!true>
        qa {
            initWith debug
            debuggable true
            applicationIdSuffix versions.appIdSuffixQa
            manifestPlaceholders += [
                appIcon: "@drawable/ic_launcher_qa",
                appIconRound: "@drawable/ic_launcher_round_qa"
            ]
        }
        
        </#if>
        dev {
            initWith debug
            debuggable true
            applicationIdSuffix versions.appIdSuffixDev
            manifestPlaceholders += [
                appIcon: "@drawable/ic_launcher_dev",
                appIconRound: "@drawable/ic_launcher_round_dev"
            ]
        }
    }
}

android.variantFilter { variant ->
    if(variant.buildType.name.endsWith('release') || variant.buildType.name.endsWith('debug')) {
variant.setIgnore(true)
    }
}

apply from: "$project.rootDir/tools/flavors.gradle"
apply from: "$project.rootDir/tools/dependencies.gradle"