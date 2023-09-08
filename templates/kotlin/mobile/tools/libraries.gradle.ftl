ext.libraries = [

    kotlin  : [
        base: "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"
    ],
<#if configs.hasOneSignal!true>

    oneSignal : [
        <#list configs.oneSignal.dependencies?keys as key>
        ${key} : "${configs.oneSignal.dependencies[key].group}:$versions.oneSignalVersion"<#if (key_index+1) < dependency.list?keys?size>,</#if>
        </#list>
    ],
</#if>
<#if configs.hasFirebase!true>
<#if configs.firebase.dependencies??>

    firebase : [
        <#list configs.firebase.dependencies?keys as key>
        ${key} : "${configs.firebase.dependencies[key]}<#if key == "base">:$versions.firebaseVersion</#if>"<#if (key_index+1) < configs.firebase.dependencies?keys?size>,</#if>
        </#list>
    ],
</#if>
</#if>
<#if configs.hasDaggerHilt!true>
<#if configs.daggerHilt.dependencies??>

    hilt : [
        <#list configs.daggerHilt.dependencies?keys as key>
        <#if configs.daggerHilt.dependencies[key].version??>${key} : "${configs.daggerHilt.dependencies[key].group}:$versions.hilt${key?capitalize?replace(" ", "")?trim}Version"<#else>${key} : "${configs.daggerHilt.dependencies[key].group}:$versions.hiltVersion"</#if><#if (key_index+1) < dependency.list?keys?size>,</#if>
        </#list>
    ],
</#if>
</#if>
<#if configs.dependencies??>
    <#list configs.dependencies as dependency>

    ${dependency.name?capitalize?replace(" ", "")?trim?uncap_first} : [
        <#list dependency.list?keys as key>
        <#if dependency.list[key].version??>${key} : "${dependency.list[key].group}:$versions.${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}${key?capitalize?replace(" ", "")?trim}Version"<#else>${key} : "${dependency.list[key].group}:$versions.${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}Version"</#if><#if (key_index+1) < dependency.list?keys?size>,</#if>
        </#list>
    ]<#if (dependency_index+1) < configs.dependencies?size>,</#if>
    </#list>
</#if>

]