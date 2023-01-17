KEYSTORE_PATH=C:\\Users\\andre\\StudioProjects\\network-demos\\keystore\\keystore.jks
KEYSTORE_PASSWORD=123456
KEYSTORE_ALIAS_PASSWORD=123456
KEYSTORE_ALIAS=demo
<#if configs.hasFirebase!true>
FIREBASE_APP_ID_DEV=${configs.firebaseDistribution.ids.dev}
FIREBASE_APP_ID_PROD=${configs.firebaseDistribution.ids.prod}
FIREBASE_APP_ID_QA=${configs.firebaseDistribution.ids.qa}
FIREBASE_GROUPS=<#list configs.firebaseDistribution.groups as group>${group}<#if (group_index+1) < configs.firebaseDistribution.groups?size>, </#if></#list>
</#if>