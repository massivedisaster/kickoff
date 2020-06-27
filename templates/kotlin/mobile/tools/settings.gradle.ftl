import java.text.Normalizer

android {

    applicationVariants.all { variant ->
        def versionCode = 0
        def applicationId = "${configs.packageName}"
        def flavors = variant.getProductFlavors()
        def buildType = variant.buildType.name
        def appName = flavors.extension.appName[0]

        applicationId += '' + flavors[0].extension.clientId + ''

        if (variant.buildType.isDebuggable()) {
            versionCode = gitVersionCodeTime
            appName += " " + buildType.toUpperCase()
        } else {
            versionCode = gitVersionCode
        }

        variant.buildConfigField 'String', 'API_BASE_URL', '\"' + flavors[0].extension.endpoints[buildType] + '\"'
        if (flavors[0].extension.manifestKeys != null && !flavors[0].extension.manifestKeys.isEmpty()) {
            for ( e in flavors[0].extension.manifestKeys[buildType] ) {
                variant.mergedFlavor.manifestPlaceholders.put(e.key, e.value)
            }
        }
        if (flavors[0].extension.extraBuildVars != null && !flavors[0].extension.extraBuildVars.isEmpty()) {
            for ( e in flavors[0].extension.extraBuildVars[buildType] ) {
                variant.buildConfigField 'String', e.key, '\"' + e.value + '\"'
            }
        }

        variant.buildConfigField 'int', 'VERSION_CODE_GIT', versionCode.toString()
        variant.buildConfigField 'String', 'VERSION_NAME_GIT', '\"' + gitVersionName + '\"'

        variant.mergedFlavor.setApplicationId(applicationId)
        variant.resValue 'string', 'app_name', '' + appName + ''

        String.metaClass.slug { ->
            def s = delegate.toLowerCase()
            s = Normalizer.normalize(s, Normalizer.Form.NFD).replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
            s = s.replaceAll(/[^a-z0-9\s-]/, "").replaceAll(/\s+/, " ").trim()
            s = s.replaceAll(/\s/, '-')
            s.replaceAll(/-{2,}/, '-')
        }

        variant.outputs.each { output ->
            output.versionNameOverride = gitVersionName
            output.versionCodeOverride = versionCode
            output.outputFileName = "${r"${flavors.extension.appName[0].slug()}-${gitVersionName}-${buildType}.apk"}"
        }
    }

    productFlavors.whenObjectAdded { flavor ->
        flavor.extensions.create("extension", AppFlavorExtension)
    }

    /*tasks.whenTaskAdded { task ->
        if (task.name.startsWith("bundle")) {
            def renameTaskName = "rename${r"${task.name.capitalize()}"}Aab"
            def flavor = task.name.substring("bundle".length()).uncapitalize()
            tasks.create(renameTaskName, Copy) {
                def path = "${r"${buildDir}/outputs/bundle/${flavor}/"}"
                from(path)
                include "app.aab"
                destinationDir file("${r"${buildDir}/outputs/renamedBundle/"}")
                rename "app.aab", "${r"${flavor}.aab"}"
            }

            task.finalizedBy(renameTaskName)
        }
    }*/

}

class AppFlavorExtension {
    String clientId = ""
    String appName
    Map endpoints
    Map manifestKeys
    Map extraBuildVars

    void setClientId(String id) {
        clientId = id
    }

    String getClientId() {
        clientId
    }

    void setAppName(String name) {
        appName = name
    }

    String getAppName() {
        appName
    }

    void setEndpoints(Map endpoints) {
        this.endpoints = endpoints
    }

    Map getEndpoints() {
        endpoints
    }

    Map getManifestKeys() {
        return manifestKeys
    }

    void setManifestKeys(Map manifestKeys) {
        this.manifestKeys = manifestKeys
    }

    Map getExtraBuildVars() {
        return extraBuildVars
    }

    void setExtraBuildVars(Map extraBuildVars) {
        this.extraBuildVars = extraBuildVars
    }

    @Override
    String toString() {
        String ret = ""
        ret += "ClientId: " + clientId + "\n"
        ret += "AppName: " + appName + "\n"
        ret += "Endpoint: " + endpoints + "\n"
        ret += "ManifestKeys: " + manifestKeys + "\n"
        ret += "ExtraBuildVars: " + extraBuildVars + "\n"
        return ret
    }
}