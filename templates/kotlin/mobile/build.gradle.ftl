buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    ext.android_version = '${configs.gradlePluginVersion}'
    dependencies {
<#if configs.hasFirebase!true>
        classpath 'com.google.gms:google-services:4.3.14'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.2'
        classpath 'com.google.firebase:perf-plugin:1.4.2'
</#if>
    }
}

// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version "android_version" apply false
    id 'com.android.library' version "android_version" apply false
    id 'org.jetbrains.kotlin.android' version "$kotlin_version" apply false
    id 'org.jetbrains.kotlin.kapt' version "$kotlin_version" apply false
    id 'com.google.dagger.hilt.android' version '2.44.2' apply false
    id 'com.github.ben-manes.versions' version '0.44.0' apply true
}
