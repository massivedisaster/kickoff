android {
    productFlavors {
        app {

            def appName = "${configs.projectName}"

            defaultConfig {
                applicationId "${configs.packageName}"
                versionCode 1
                versionName "0.0.1"
            }

            buildTypes {
                prod {       
                    resValue ("string", "app_name", appName)
                    <#if configs.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.retrofit.prod}\"")
                    </#if>
					<#if configs.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "true")
                    </#if>
					<#if configs.onesignal??>
					manifestPlaceholders += [onesignal_app_id: "${configs.onesignal.prod.appId}",
                              onesignal_google_project_number: "${configs.onesignal.prod.googleProjectNumber}"]
                    </#if>
                }

                dev {                   
                    resValue ("string", "app_name", appName + " DEV")
                    <#if configs.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.retrofit.dev}\"")
                    </#if>
					<#if configs.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "true")
                    </#if>
					<#if configs.onesignal??>
					manifestPlaceholders += [onesignal_app_id: "${configs.onesignal.dev.appId}",
                              onesignal_google_project_number: "${configs.onesignal.dev.googleProjectNumber}"]
                    </#if>
                }
                <#if configs.hasQa!true>
                qa {                
                    resValue ("string", "app_name", appName + " QA")
                    <#if configs.retrofit??>
                    buildConfigField ("String", "API_BASE_URL", "\"${configs.retrofit.qa}\"")
                    </#if>
					<#if configs.fabrickey??>
                    buildConfigField ("boolean", "CRASHLYTICS_ENABLED", "false")
                    </#if>
					<#if configs.onesignal??>
					manifestPlaceholders += [onesignal_app_id: "${configs.onesignal.qa.appId}",
                              onesignal_google_project_number: "${configs.onesignal.qa.googleProjectNumber}"]
                    </#if>
                }
                </#if>
            }
        }
    }
}