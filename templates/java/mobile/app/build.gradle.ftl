buildscript {
    repositories {
        jcenter()
        <#if configs.fabrickey??>
            maven { url 'https://maven.fabric.io/public' }
        </#if>
    }
    dependencies {
        <#if configs.fabrickey??>
        classpath 'io.fabric.tools:gradle:1.22.1'
        </#if>
        <#if configs.qualityVerifier??>
        classpath 'pt.simdea.verifier:verifier:3.5.0'
        </#if>
    }
}

<#if configs.fabrickey??>
repositories {
    maven { url 'https://maven.fabric.io/public' }
}

</#if>
apply plugin: 'com.android.application'

android {
    compileSdkVersion ${configs.targetSdkApi}
    buildToolsVersion '${configs.buildTools}'

    defaultConfig {
        minSdkVersion ${configs.minimumSdkApi}
        targetSdkVersion ${configs.targetSdkApi}
        <#if configs.retrofit??>
        	buildConfigField ("long", "API_TIMEOUT", "${configs.retrofit.timeout}")
        </#if>
    }

    buildTypes {
        prod {
            initWith release
            debuggable false
            manifestPlaceholders += [
                    appIcon: "@mipmap/ic_launcher"
            ]
        }

        <#if configs.hasQa!true>
        qa {
            initWith debug
            debuggable true
            applicationIdSuffix ".qa"
            versionNameSuffix "-QA"
            manifestPlaceholders += [
                    appIcon: "@drawable/ic_launcher_qa"
            ]
        }
        
        </#if>
        dev {
            initWith debug
            debuggable true
            applicationIdSuffix ".dev"
            versionNameSuffix "-DEV"
            manifestPlaceholders += [
                    appIcon: "@drawable/ic_launcher_dev"
            ]
        }
    }
    <#if configs.qualityVerifier?? && configs.qualityVerifier.lint!true>
    
    lintOptions {
        disable 'InvalidPackage'
        disable 'IconLauncherFormat'
    }
    </#if>
}

android.variantFilter { variant ->
    if(variant.buildType.name.endsWith('release') || variant.buildType.name.endsWith('debug')) {
        variant.setIgnore(true);
    }
}

<#if configs.fabrickey??>
apply plugin: 'io.fabric'
</#if>
apply from: 'flavors.gradle'
apply from: 'dependencies.gradle'
<#if configs.qualityVerifier??>
apply from: 'quality.gradle'
apply plugin: 'pt.simdea.verifier'
</#if>