ext.libraries = [

    kotlin  : [
        base: "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    ],
<#if configs.dependencies??>
    <#list configs.dependencies as dependency>

    ${dependency.name?capitalize?replace(" ", "")} : [
        <#list dependency.list?keys as key>
        <#if dependency.list[key].version??>${key} : "${dependency.list[key].group}:$versions.${dependency.name?capitalize?replace(" ", "")}${key?capitalize?replace(" ", "")}Version"<#else>${key} : "${dependency.list[key].group}:$versions.${dependency.name?lower_case?replace(" ", "")}Version"</#if><#if (key_index+1) < dependency.list?keys?size>,</#if>
        </#list>
    ]<#if (dependency_index+1) < configs.dependencies?size>,</#if>
    </#list>
</#if>
]