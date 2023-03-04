KEYSTORE_PATH=fullpath.ks
KEYSTORE_PASSWORD=pass
KEYSTORE_ALIAS_PASSWORD=pass
KEYSTORE_ALIAS=demo
<#if configs.hasFirebase!true>
FIREBASE_PATH=/usr/local/bin/firebase
FIREBASE_APP_ID_DEV=${configs.firebase.distribution.ids.dev}
FIREBASE_APP_ID_PROD=${configs.firebase.distribution.ids.prod}
FIREBASE_APP_ID_QA=${configs.firebase.distribution.ids.qa}
FIREBASE_GROUPS=<#list configs.firebase.distribution.groups as group>${group}<#if (group_index+1) < configs.firebase.distribution.groups?size>, </#if></#list>
</#if>