ext.versions = [

        // DEPENDENCIES VERSIONS
<#if configs.dependencies??>
        <#list configs.dependencies as dependency>
        ${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}Version: '${dependency.globalVersion}',
        <#list dependency.list?keys as key>
                <#if dependency.list[key].version??>
        ${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}${key?capitalize?replace(" ", "")?trim}Version: '${dependency.list[key].version}',
                </#if>
        </#list>
        </#list>
</#if>
<#if configs.hasOneSignal!true>
        oneSignalVersion: '[3.9.1, 3.99.99]',
</#if>

        // ANDROID CONFIGS
        compileSdk: ${configs.targetSdkApi},
        targetSdk: ${configs.targetSdkApi},
        minSdk: ${configs.minimumSdkApi},

        // BUILD PROPERTIES
        appIdSuffixDev: '.dev',
<#if configs.hasQa!true>
        appIdSuffixQa: '.qa'
</#if>
]