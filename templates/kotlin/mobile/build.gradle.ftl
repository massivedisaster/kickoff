apply plugin: "com.github.ben-manes.versions"
buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        <#if configs.hasOneSignal!true>
        maven { url 'https://plugins.gradle.org/m2/'}
        </#if>
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:${configs.gradlePluginVersion}'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.5'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.5.2'
        classpath "com.github.ben-manes:gradle-versions-plugin:0.38.0"
        <#if configs.hasOneSignal!true>
        classpath 'gradle.plugin.com.onesignal:onesignal-gradle-plugin:[0.12.4, 0.99.99]'
        </#if>
        <#if configs.hasFirebasePerformance!true>
        classpath 'com.google.firebase:perf-plugin:1.3.5'
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