dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    <#if configs.dependencies.fabrickey??>

    /* FABRIC CRASHLYTICS */
    implementation("com.crashlytics.sdk.android:crashlytics:$project.fabricCrashlyticsVersion") {
        transitive = true;
    }
    </#if>
    <#if configs.dependencies.onesignal??>

    /* ONESIGNAL */
    implementation "com.onesignal:OneSignal:$project.oneSignalVersion"
    </#if>
    <#if configs.dependencies.others??>
    <#list configs.dependencies.others>
    <#items as dependency>

    /* ${dependency.name} */
    <#list dependency.list as dep>
    implementation "${dep}:$project.${dependency.name?lower_case?replace(" ", "")}Version"
    </#list>
    </#items>
    </#list>
    </#if>
}