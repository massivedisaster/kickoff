ext.versions = [

<#if configs.dependencies??>
        <#list configs.dependencies as dependency>
        ${dependency.name?capitalize?replace(" ", "")}Version: '${dependency.globalVersion}',
        <#list dependency.list?keys as key>
                <#if dependency.list[key].version??>
        ${dependency.name?capitalize?replace(" ", "")}${key?capitalize?replace(" ", "")}Version: '${dependency.list[key].version}',
                </#if>
        </#list>
        </#list>
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