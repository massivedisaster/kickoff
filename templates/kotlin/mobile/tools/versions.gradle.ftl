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
<#if configs.hasDaggerHilt!true>
        hiltVersion: '${configs.daggerHilt.version}',
        <#list configs.daggerHilt.dependencies?keys as key>
                <#if configs.daggerHilt.dependencies[key].version??>
        hilt${key?capitalize?replace(" ", "")?trim}Version: '${configs.daggerHilt.dependencies[key].version}',
                </#if>
        </#list>
</#if>
<#if configs.hasOneSignal!true>
        oneSignalVersion: '${configs.oneSignal.version}',
</#if>
<#if configs.hasFirebase!true>
        firebaseVersion: '${configs.firebase.version}',
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
