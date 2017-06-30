ext {
    adalVersion = '0.1.2'
    afmVersion = '0.2.2'
    <#if configs.fabrickey??>
    fabricCrashlyticsVersion = '2.6.6@aar'
    </#if>
    <#if configs.onesignal??>
    oneSignalVersion = '3.+@aar'
    </#if>
    <#if configs.dependencies??>
    <#list configs.dependencies>
    <#items as dependency>
    ${dependency.name?lower_case?replace(" ", "")}Version = '${dependency.version}'
    </#items>
    </#list>
    </#if>
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    /* ADAL */
    compile "com.massivedisaster.adal:adal:$adalVersion"

    /* ACTIVITY FRAGMENT MANAGER */
    compile "com.massivedisaster:activity-fragment-manager:$afmVersion"
    <#if configs.fabrickey??>

    /* FABRIC CRASHLYTICS */
    compile("com.crashlytics.sdk.android:crashlytics:$fabricCrashlyticsVersion") {
        transitive = true;
    }
    </#if>
    <#if configs.onesignal??>

    /* ONESIGNAL */
    compile "com.onesignal:OneSignal:$oneSignalVersion"
    </#if>
    <#if configs.dependencies??>
    <#list configs.dependencies>
    <#items as dependency>

    /* ${dependency.name} */
    <#list dependency.list as dep>
    compile("${dep}:$${dependency.name?lower_case?replace(" ", "")}Version")
    </#list>
    </#items>
    </#list>
    </#if>
}