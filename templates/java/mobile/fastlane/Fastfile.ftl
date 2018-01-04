# Customize this file, documentation can be found here:
# https://docs.fastlane.tools/actions/
# All available actions: https://docs.fastlane.tools/actions
# can also be listed using the `fastlane actions` command

# Change the syntax highlighting to Ruby
# All lines starting with a # are ignored when running `fastlane`

# If you want to automatically update fastlane if a new version is available:
# update_fastlane

# This is the minimum version number required.
# Update this, if you use features of a newer version
min_fastlane_version("2.72.0")

default_platform(:android)

platform :android do
  before_all do
    # ENV["SLACK_URL"] = "https://hooks.slack.com/services/..."
    ENV["SLACK_URL"] = ""
  end

  desc "Runs all the tests"
  lane :test do
    gradle(task: "test")
  end

  desc "Submit a new Dev Build to Beta by Crashlytics"
  lane :build_dev do
    gradle(task: "clean")
    gradle(task: 'assemble', flavor: 'app', build_type: 'dev')
    gradle(task: "connectedCheck")

    send_crashlytics

    changelog = changelog_from_git_commits
    changelog = "No changes" if changelog.to_s.length == 0
  end
  <#if configs.hasQa!true>

  desc "Submit a new QA Build to Beta by Crashlytics"
  lane :build_qa do
    gradle(task: "clean")
    gradle(task: 'assemble', flavor: 'app', build_type: 'qa')
    gradle(task: "connectedCheck")

    send_crashlytics

    changelog = changelog_from_git_commits
    changelog = "No changes" if changelog.to_s.length == 0
  end
  </#if>

  lane :send_crashlytics do |options|
    crashlytics(api_token: options[:crashlytics_api],
                build_secret: options[:crashlytics_secret],
                groups: ["CARBON QA"])
  end


# See https://github.com/appfoundry/fastlane-android-example
  #desc "Deploy a new version to the Google Play"
  #lane :deploy do
  #  gradle(task: "assembleProd")
  #  upload_to_play_store
  #end

  # You can define as many lanes as you want

  after_all do |lane|
    # This block is called, only if the executed lane was successful

    # slack(
    #   message: "Successfully deployed new App Update."
    # )
  end

  error do |lane, exception|
    # slack(
    #   message: exception.message,
    #   success: false
    # )
  end
end

# More information about multiple platforms in fastlane: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
# All available actions: https://docs.fastlane.tools/actions

# fastlane reports which actions are used. No personal data is recorded.
# Learn more at https://docs.fastlane.tools/#metrics
