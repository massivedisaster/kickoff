apply plugin: "com.github.ben-manes.versions"
buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    repositories {
        google()
        jcenter()
        <#if configs.hasOneSignal!true>
        maven { url 'https://plugins.gradle.org/m2/'}
        </#if>
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:${configs.gradlePluginVersion}'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.3'
        classpath "com.github.ben-manes:gradle-versions-plugin:0.27.0"
        <#if configs.hasOneSignal!true>
        classpath 'gradle.plugin.com.onesignal:onesignal-gradle-plugin:[0.12.4, 0.99.99]'
        </#if>

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}