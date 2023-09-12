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
  lane :test do
    gradle(task: "test")
  end

  lane :build_dev do |options|
    #test
    gradle(task: 'clean')
    gradle(task: 'assemble', flavor: 'app', build_type: 'dev')

    if options[:submit]
      send_firebase(value: ENV["FIREBASE_APP_ID_DEV"])
    end
  end

  lane :build_prod do |options|
    #test
    gradle(task: 'clean')
    gradle(task: 'bundle', flavor: 'app', build_type: 'prod', print_command: false, properties: {
        "android.injected.signing.store.file" => ENV["KEYSTORE_PATH"],
        "android.injected.signing.store.password" => ENV["KEYSTORE_PASSWORD"],
        "android.injected.signing.key.alias" => ENV["KEYSTORE_ALIAS"],
        "android.injected.signing.key.password" => ENV["KEYSTORE_ALIAS_PASSWORD"],
    })

    gradle(task: 'assemble', flavor: 'app', build_type: 'prod', print_command: false, properties: {
        "android.injected.signing.store.file" => ENV["KEYSTORE_PATH"],
        "android.injected.signing.store.password" => ENV["KEYSTORE_PASSWORD"],
        "android.injected.signing.key.alias" => ENV["KEYSTORE_ALIAS"],
        "android.injected.signing.key.password" => ENV["KEYSTORE_ALIAS_PASSWORD"],
    })

    aab_path = Actions.lane_context[SharedValues::GRADLE_AAB_OUTPUT_PATH]
    apk_path = Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]
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

  lane :send_firebase do |options|
    changelog = changelog_from_git_commits(merge_commit_filtering: "exclude_merges")
    changelog = "No changes" if changelog.to_s.length == 0

    firebase_app_distribution(
      app: options[:value],
      release_notes: changelog,
      groups: ENV['FIREBASE_GROUPS'],
      firebase_cli_path: ENV['FIREBASE_PATH']
    )
  end

end
