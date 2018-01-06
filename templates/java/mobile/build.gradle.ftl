buildscript {
    repositories {
        jcenter()
        <#if configs.dependencies.fabrickey??>
        maven { url 'https://maven.fabric.io/public' }
        </#if>
        google()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:${configs.gradlePluginVersion}'
        <#if configs.qualityVerifier??>
        classpath "pt.simdea.verifier:verifier:$project.verifierVersion"
        </#if>
        <#if configs.dependencies.fabrickey??>
        classpath 'io.fabric.tools:gradle:1.22.1'
        </#if>
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        jcenter()
        google()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}