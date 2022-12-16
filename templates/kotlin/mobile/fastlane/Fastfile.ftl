# Customize this file, documentation can be found here:
# https://docs.fastlane.tools/actions/
# All available actions: https://docs.fastlane.tools/actions
# can also be listed using the `fastlane actions` command

# Change the syntax highlighting to Ruby
# All lines starting with a # are ignored when running `fastlane`

# If you want to automatically update fastlane if a new version is available:
update_fastlane

# This is the minimum version number required.
# Update this, if you use features of a newer version
# min_fastlane_version("2.72.0")

default_platform :android

platform :android do

  #desc "Runs all the tests"
  #lane :test do
  #  gradle(task: "test")
  #end

  lane :build_dev do |options|
    #test
    gradle(task: 'clean')
    gradle(task: 'assemble', flavor: 'app', build_type: 'dev')

    if options[:submit]
      send_firebase(value: ENV["FIREBASE_APP_ID_DEV"])
    else
      ENV["FL_SLACK_MESSAGE"] = "Build successfully!"
    end
  end

  lane :build_prod do |options|
    #test
    gradle(task: 'clean')
    gradle(task: 'assemble', flavor: 'app', build_type: 'prod',
           print_command: false, properties: { })

    if options[:submit]
      send_firebase(value: ENV["FIREBASE_APP_ID_PROD"])
    end
  end
  <#if configs.hasQa!true>

  lane :build_qa do |options|
    #test
    gradle(task: "clean")
    gradle(task: 'assemble', flavor: 'app', build_type: 'qa')

    if options[:submit]
      send_firebase(value: ENV["FIREBASE_APP_ID_QA"])
    end
  end
  </#if>

  lane :send_testfairy do |options|
    changelog = changelog_from_git_commits(merge_commit_filtering: "exclude_merges")
    changelog = "No changes" if changelog.to_s.length == 0

    testfairy(
      api_key: ENV["TEST_FAIRY_API_KEY"],
      comment: changelog,
      testers_groups: ENV['TEST_FAIRY_TESTER_GROUP'],
      notify: "on"
    )

    @testfairy_build_url = lane_context[SharedValues::TESTFAIRY_BUILD_URL]

    ENV["FL_SLACK_MESSAGE"] = "A new version has been uploaded on TestFairy! \n Version: #@app_version \n URL: #@testfairy_build_url"
  end

  lane :send_firebase do |options|
    changelog = changelog_from_git_commits(merge_commit_filtering: "exclude_merges")
    changelog = "No changes" if changelog.to_s.length == 0

    firebase_app_distribution(
      app: options[:value],
      release_notes: changelog,
      groups: ENV['FIREBASE_GROUPS'],
      firebase_cli_path: "/usr/local/bin/firebase"
    )

    ENV["FL_SLACK_MESSAGE"] = "A new version has been uploaded on Firebase! \n Version: #@app_version"
  end

  desc "For every error we send a Slack message"
  error do |lane, exception, options|

    @lane_name = lane
    @error_message = exception.message

    #slack(message: "#@error_message", success: false)

  end

  desc "After executing the lane we send a custom Slack message using FL_SLACK_MESSAGE env variable"
  after_all do |lane|

    #slack(success: true)

  end

end
