apply plugin: "com.github.ben-manes.versions"
buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:${configs.gradlePluginVersion}'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath "com.google.dagger:hilt-android-gradle-plugin:2.44.2"
        classpath 'com.google.gms:google-services:4.3.14'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.2'
        classpath "com.github.ben-manes:gradle-versions-plugin:0.44.0"
        <#if configs.hasFirebasePerformance!true>
        classpath 'com.google.firebase:perf-plugin:1.4.1'
        </#if>
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}