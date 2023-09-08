plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'kotlin-kapt'
    id 'kotlin-parcelize'
    <#if configs.hasDaggerHilt!true>
    id 'dagger.hilt.android.plugin'
    </#if>
    <#if configs.hasFirebase!true>
    id 'com.google.firebase.crashlytics'
    id 'com.google.firebase.firebase-perf'
    </#if>
}
apply from: "$project.rootDir/tools/versions.gradle"

android {

    namespace "${configs.packageName}"
    compileSdk versions.compileSdk

    defaultConfig {
        applicationId "${configs.packageName}"
        minSdk versions.minSdk
        targetSdk versions.targetSdk
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    buildFeatures {
        dataBinding = true
    }

    packagingOptions {
        resources {
            excludes += ['LICENSE.txt', 'META-INF/LICENSE.txt', 'META-INF/NOTICE.txt', 'META-INF/ASL2.0', 'META-INF/LICENSE', 'META-INF/NOTICE']
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
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

    androidComponents {
        beforeVariants(selector().all()) {
            enabled = !(buildType == "debug" || buildType == "release")
        }
    }
}

apply from: "$project.rootDir/tools/flavors.gradle"
apply from: "$project.rootDir/tools/dependencies.gradle"

//TODO add google-services.json before uncomment
//apply plugin: 'com.google.gms.google-services'