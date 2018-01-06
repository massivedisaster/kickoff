apply plugin: 'com.android.application'
<#if configs.dependencies.fabrickey??>
apply plugin: 'io.fabric'
</#if>
apply from: "$project.rootDir/tools/git-version.gradle"
<#if configs.qualityVerifier??>
apply plugin: 'pt.simdea.verifier'
</#if>

android {

    compileSdkVersion project.COMPILE_SDK_VERSION.toInteger()
    buildToolsVersion project.BUILD_TOOLS_VERSION

    defaultConfig {
        applicationId project.APP_ID
        minSdkVersion project.MIN_SDK_VERSION.toInteger()
        targetSdkVersion project.TARGET_SDK_VERSION.toInteger()
        <#if configs.dependencies.retrofit??>
        	buildConfigField ("long", "API_TIMEOUT", "${configs.dependencies.retrofit.timeout}")
        </#if>
    }

    packagingOptions {
        exclude 'LICENSE.txt'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/ASL2.0'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/NOTICE'
    }

    buildTypes {
        prod {
            initWith release
            debuggable false
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), "$project.rootDir/tools/rules-proguard.pro"
            manifestPlaceholders += [
                    appIcon: "@mipmap/ic_launcher"
            ]
        }

        <#if configs.hasQa!true>
        qa {
            initWith debug
            debuggable true
            applicationIdSuffix project.QA_APP_ID_SUFFIX
            versionNameSuffix project.QA_VERSION_NAME_SUFFIX
            manifestPlaceholders += [
                    appIcon: "@drawable/ic_launcher_qa"
            ]
        }
        
        </#if>
        dev {
            initWith debug
            debuggable true
            applicationIdSuffix project.DEV_APP_ID_SUFFIX
            versionNameSuffix project.DEV_VERSION_NAME_SUFFIX
            manifestPlaceholders += [
                    appIcon: "@drawable/ic_launcher_dev"
            ]
        }
    }
    <#if configs.qualityVerifier?? && configs.qualityVerifier.lint??>
    
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

apply from: "$project.rootDir/tools/flavors.gradle"
apply from: "$project.rootDir/tools/dependencies.gradle"
<#if configs.qualityVerifier??>
apply from: "$project.rootDir/tools/quality.gradle"
</#if>