# ${configs.projectName} - Android #
All the information needed to run this android project.
Actual version: 0.0.0

### Endpoints ###
**DEV**
```
-
```
<#if configs.hasQa!true>
**QA**
```
-
```
</#if>
**PROD**
```
-
```
### API Keys ###
**DEV**

<#if configs.hasOnesignal!true>
***OneSignal***
```
OneSignal App ID: -
Project Number: -
Project ID: -
```
</#if>
<#if configs.hasQa!true>
**QA**

<#if configs.hasOnesignal!true>
***OneSignal***
```
OneSignal App ID: -
Project Number: -
Project ID: -
```
</#if>
</#if>
**PROD**

<#if configs.hasOnesignal!true>
***OneSignal***
```
OneSignal App ID: -
Project Number: -
Project ID: -
```
</#if>

### Run information ###

#### Keystore to make prod build ####
Keystore file is in folder named "`keystore`" in root project folder
```text
alias: -
password: -
```