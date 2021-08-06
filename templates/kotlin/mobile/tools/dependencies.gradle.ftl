apply from: "$project.rootDir/tools/libraries.gradle"

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar', '*.aar'])

    /* KOTLIN */
    implementation libraries.kotlin.base
<#if configs.dependencies??>
    <#list configs.dependencies as dependency>

    /* ${dependency.name?upper_case} */
    <#list dependency.list?keys as key>
    <#if dependency.list[key].isCompiler!true>kapt<#else>implementation</#if> libraries.${dependency.name?capitalize?replace(" ", "")?trim?uncap_first}.${key}
    </#list>
    </#list>
</#if>

<#if configs.hasOneSignal!true>
    /* ONE SIGNAL */
    implementation(libraries.oneSignal.base) {
        exclude group: 'com.google.firebase', module: 'firebase-messaging'
        exclude group: 'com.google.android.gms', module: 'play-services-gcm'
        exclude group: 'com.google.android.gms', module: 'play-services-analytics'
        exclude group: 'com.google.android.gms', module: 'play-services-location'
    }
</#if>

}