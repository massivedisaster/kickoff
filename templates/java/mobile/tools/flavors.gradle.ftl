android {

    applicationVariants.all { variant ->
        def versionCode = 0
        def versionName = ""

        println(variant.buildType.name)
        if (variant.buildType.isDebuggable()) {
            versionCode = gitVersionCodeTime
            versionName = gitVersionName
        } else {
            versionCode = gitVersionCode
            versionName = gitVersionName
        }

        variant.mergedFlavor.versionCode = versionCode
        variant.mergedFlavor.versionName = versionName

        variant.outputs.all { output ->
            output.setVersionNameOverride(versionName)
            output.setVersionCodeOverride(versionCode)
        }
    }

    flavorDimensions 'build'

    productFlavors {

        app {
            dimension 'build'
            def appName = "${configs.projectName}"

            buildTypes {
                prod {
                    resValue ("string", "app_name", appName)
                    <#if configs.dependencies.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.dependencies.retrofit.prod}\"")
                    </#if>
					<#if configs.dependencies.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "true")
                    </#if>
                    <#if configs.dependencies.onesignal??>
                    manifestPlaceholders += [onesignal_app_id: "${configs.dependencies.onesignal.prod.appId}",
                    onesignal_google_project_number: "${configs.dependencies.onesignal.prod.googleProjectNumber}"]
                    </#if>
                }

                dev {
                    resValue ("string", "app_name", appName + " DEV")
                    <#if configs.dependencies.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.dependencies.retrofit.dev}\"")
                    </#if>
					<#if configs.dependencies.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "false")
                    </#if>
                    <#if configs.dependencies.onesignal??>
                    manifestPlaceholders += [onesignal_app_id: "${configs.dependencies.onesignal.dev.appId}",
                    onesignal_google_project_number: "${configs.dependencies.onesignal.dev.googleProjectNumber}"]
                    </#if>
                }
                <#if configs.hasQa!true>

                qa {
                    resValue ("string", "app_name", appName + " QA")
                    <#if configs.dependencies.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.dependencies.retrofit.qa}\"")
                    </#if>
					<#if configs.dependencies.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "false")
                    </#if>
                    <#if configs.dependencies.onesignal??>
                    manifestPlaceholders += [onesignal_app_id: "${configs.dependencies.onesignal.qa.appId}",
                    onesignal_google_project_number: "${configs.dependencies.onesignal.qa.googleProjectNumber}"]
                    </#if>
                }
                </#if>
            }
        }
    }
}