import java.text.Normalizer

ext {
    gitVersionName = grgit.describe(tags: true, always: true)
    gitVersionCode = grgit.tag.list().size()
    gitVersionCodeTime = grgit.head().dateTime.toEpochSecond()
}

tasks.register('printVersion') {
    println("Version Name: $gitVersionName")
    println("Version Code: $gitVersionCode")
    println("Version Code Time: $gitVersionCodeTime")
}

android {

    applicationVariants.all { variant ->
        def versionCode = 0
        def applicationId = "${configs.packageName}"
        def flavors = variant.getProductFlavors()
        def buildType = variant.buildType.name
        def appName = flavors.extension.appName[0]

        if (variant.buildType.isDebuggable()) {
            versionCode = gitVersionCodeTime
            appName += " " + buildType.toUpperCase()
        } else {
            versionCode = gitVersionCode + flavors[0].extension.versionCodeExtra
        }

        variant.buildConfigField 'String', 'API_BASE_URL', '\"' + flavors[0].extension.endpoints[buildType] + '\"'
<#if configs.network??>
        variant.buildConfigField 'long', 'API_TIMEOUT', '${configs.network.timeout}'
</#if>
        //MANIFEST KEYS
        if (flavors[0].extension.manifestKeys != null && !flavors[0].extension.manifestKeys.isEmpty()) {
            for ( e in flavors[0].extension.manifestKeys[buildType] ) {
                variant.mergedFlavor.manifestPlaceholders.put(e.key, e.value)
            }
        }

        //RESVALUES
        if (flavors[0].extension.resValues != null && !flavors[0].extension.resValues.isEmpty()) {
            for ( e in flavors[0].extension.resValues[buildType] ) {
                variant.resValue 'string', e.key, '' + e.value + ''
            }
        }

        //EXTRA BUILD VARS
        if (flavors[0].extension.extraBuildVars != null && !flavors[0].extension.extraBuildVars.isEmpty()) {
            for ( e in flavors[0].extension.extraBuildVars[buildType] ) {
                variant.buildConfigField 'String', e.key, '\"' + e.value + '\"'
            }
        }

        if (flavors[0].extension.clientId != null && !flavors[0].extension.clientId.isEmpty()) {
            applicationId += '' + flavors[0].extension.clientId
            if (buildType == 'dev') {
                applicationId += versions.appIdSuffixDev
            } else if (buildType == 'qa') {
                applicationId += versions.appIdSuffixQa
            }
            variant.mergedFlavor.setApplicationId(applicationId)
        }
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

        //println(flavors.extension.toString())
    }

    productFlavors.whenObjectAdded { flavor ->
        flavor.extensions.create("extension", AppFlavorExtension)
    }

}

class AppFlavorExtension {
    String clientId = ""
    String appName
    int versionCodeExtra = 0
    Map endpoints
    Map manifestKeys
    Map resValues
    Map extraBuildVars

    void setClientId(String id) {
        clientId = id
    }

    String getClientId() {
        clientId
    }

    void setVersionCodeExtra(int extra) {
        versionCodeExtra = extra
    }

    int getVersionCodeExtra() {
        versionCodeExtra
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

    Map getResValues() {
        return resValues
    }

    void setResValues(Map resValues) {
        this.resValues = resValues
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
        ret += "VersionCodeExtra: " + versionCodeExtra + "\n"
        ret += "AppName: " + appName + "\n"
        ret += "Endpoint: " + endpoints + "\n"
        ret += "ManifestKeys: " + manifestKeys + "\n"
        ret += "ResValues: " + resValues + "\n"
        ret += "ExtraBuildVars: " + extraBuildVars + "\n"
        return ret
    }
}