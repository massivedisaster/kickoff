apply plugin: "com.github.ben-manes.versions"
buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:${configs.gradlePluginVersion}'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.0'
        classpath "com.github.ben-manes:gradle-versions-plugin:0.21.0"

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