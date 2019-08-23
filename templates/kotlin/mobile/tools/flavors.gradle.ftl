apply from: "$project.rootDir/tools/settings.gradle"

android {

    flavorDimensions 'build'

    productFlavors {

        app {
            dimension 'build'

            extension.appName "${configs.projectName}"
<#if configs.network??>
            extension.setEndpoints([
    <#list configs.network.endpoints?keys as key>
                ${key}: "${configs.network.endpoints[key]}"<#if (key_index+1) < configs.network.endpoints?keys?size>,</#if>
    </#list>
            ])
</#if>
<#if configs.manifestKeys??>
            extension.setManifestKeys([
    <#list configs.manifestKeys?keys as buildType>
                ${buildType}: [
        <#list configs.manifestKeys[buildType]?keys as key>
                    ${key}: "${configs.manifestKeys[buildType][key]}"<#if (key_index+1) < configs.manifestKeys[buildType]?size>,</#if>
        </#list>
                ]<#if (buildType_index+1) < configs.manifestKeys?keys?size>,</#if>
    </#list>
            ])
</#if>
<#if configs.extraBuildVars??>
            extension.extraBuildVars([
    <#list configs.extraBuildVars?keys as buildType>
                ${buildType}: [
          <#list configs.extraBuildVars[buildType]?keys as key>
                    ${key}: "${configs.extraBuildVars[buildType][key]}"<#if (key_index+1) < configs.extraBuildVars[buildType]?size>,</#if>
          </#list>
                ]<#if (buildType_index+1) < configs.extraBuildVars?size>,</#if>
    </#list>
            ])
</#if>
        }

    }
}