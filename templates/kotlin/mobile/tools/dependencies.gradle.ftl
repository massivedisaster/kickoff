apply from: "$project.rootDir/tools/libraries.gradle"

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])

    /* KOTLIN */
    implementation libraries.kotlin.base
<#if configs.dependencies??>
    <#list configs.dependencies as dependency>

    /* ${dependency.name?upper_case} */
        <#list dependency.list?keys as key>
    <#if dependency.list[key].isCompiler!true>kapt<#else>implementation</#if> libraries.${dependency.name?capitalize?replace(" ", "")}.${key}
        </#list>
    </#list>
</#if>
}