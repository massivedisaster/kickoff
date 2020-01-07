#Slack
ENV["SLACK_URL"] = "${configs.slack.slug}"
ENV["FL_SLACK_ICON_URL"] = "https://wiki.jenkins.io/download/attachments/2916393/headshot.png?version=1&modificationDate=1302753947000&api=v2"
ENV["FL_SLACK_DEFAULT_PAYLOADS"] = ":lane"
ENV["FL_SLACK_USERNAME"] = "Jenkins Android"
ENV["FL_SLACK_CHANNEL"] = "${configs.slack.channel}"

#Testfairy
ENV["TEST_FAIRY_API_KEY"] = "${configs.testFairy.key}"
ENV["TEST_FAIRY_TESTER_GROUP"] = [<#list configs.testFairy.groups as group>"${group}"<#if (group_index+1) < configs.testFairy.groups?size>, </#if></#list>]

#Firebase
ENV["FIREBASE_APP_ID_DEV"] = "${configs.firebaseDistribution.ids.dev}"
ENV["FIREBASE_APP_ID_PROD"] = "${configs.firebaseDistribution.ids.prod}"
ENV["FIREBASE_APP_ID_QA"] = "${configs.firebaseDistribution.ids.qa}"
ENV["FIREBASE_GROUPS"] = "<#list configs.firebaseDistribution.groups as group>${group}<#if (group_index+1) < configs.firebaseDistribution.groups?size>, </#if></#list>"