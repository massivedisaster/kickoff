#Slack
ENV["SLACK_URL"] = "${configs.slackSlug}"
ENV["FL_SLACK_ICON_URL"] = "https://wiki.jenkins.io/download/attachments/2916393/headshot.png?version=1&modificationDate=1302753947000&api=v2"
ENV["FL_SLACK_DEFAULT_PAYLOADS"] = ":lane"
ENV["FL_SLACK_USERNAME"] = "Jenkins Android"
ENV["FL_SLACK_CHANNEL"] = "${configs.slackChannel}"

#Test Fairy
ENV["TEST_FAIRY_API_KEY"] = "${configs.testFairyKey}"
ENV["TEST_FAIRY_TESTER_GROUP"] = ["Fastlane"]