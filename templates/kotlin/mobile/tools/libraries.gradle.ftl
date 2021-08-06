ext.libraries = [

    kotlin  : [
        base: "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"
    ],
<#if configs.hasOneSignal!true>

    oneSignal : [
        base : "com.onesignal:OneSignal:$versions.oneSignalVersion"
    ],
</#if><#if configs.dependencies??>
    <#list configs.dependencies as dependency>

    ${dependency.name?capitalize?replace(" ", "")?trim?uncap_first} : [
        <#list dependency.list?keys as key>
        <#if dependency.list[key].version??>${key} : "${dependency.list[key].group}:$versions.${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}${key?capitalize?replace(" ", "")?trim}Version"<#else>${key} : "${dependency.list[key].group}:$versions.${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}Version"</#if><#if (key_index+1) < dependency.list?keys?size>,</#if>
        </#list>
    ]<#if (dependency_index+1) < configs.dependencies?size>,</#if>
    </#list>
</#if>

]