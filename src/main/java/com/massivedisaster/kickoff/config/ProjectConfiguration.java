package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;
import java.util.List;

public class ProjectConfiguration {

	@JsonProperty("template")
	private String template;
	@JsonProperty("language")
	private String language;
	@JsonProperty("gradlePluginVersion")
	private String gradlePluginVersion;
	@JsonProperty("gradleVersion")
	private String gradleVersion;
	@JsonProperty("projectName")
	private String projectName;
	@JsonProperty("packageName")
	private String packageName;
	@JsonProperty("minimumSdkApi")
	private int minimumSdkApi;
	@JsonProperty("targetSdkApi")
	private int targetSdkApi;
	@JsonProperty("buildTools")
	private String buildTools;
	@JsonProperty("manifestKeys")
	private HashMap<String, HashMap<String, String>> manifestKeys;
	@JsonProperty("extraBuildVars")
	private HashMap<String, HashMap<String, String>> extraBuildVars;
	@JsonProperty("network")
	private Network network;
	@JsonProperty("dependencies")
	private List<Dependency> dependencies;
	@JsonProperty("hasQa")
	private boolean hasQa;
	@JsonProperty("useAndroidX")
	private boolean useAndroidX;
	@JsonProperty("hasOneSignal")
	private boolean hasOneSignal;
	@JsonProperty("slackChannel")
	private String slackChannel;
	@JsonProperty("testFairyKey")
	private String testFairyKey;
	@JsonProperty("kotlinVersion")
	private String kotlinVersion;
	@JsonProperty("slackSlug")
	private String slackSlug;

	public String getTemplate() {
		return template;
	}

	public String getLanguage() {
		return language;
	}

	public String getGradlePluginVersion() {
		return gradlePluginVersion;
	}

	public String getGradleVersion() {
		return gradleVersion;
	}

	public String getProjectName() {
		return projectName;
	}

	public String getPackageName() {
		return packageName;
	}

	public int getMinimumSdkApi() {
		return minimumSdkApi;
	}

	public int getTargetSdkApi() {
		return targetSdkApi;
	}

	public String getBuildTools() {
		return buildTools;
	}

	public HashMap<String, HashMap<String, String>> getManifestKeys() {
		return manifestKeys;
	}

    public HashMap<String, HashMap<String, String>> getExtraBuildVars() {
        return extraBuildVars;
    }

	public Network getNetwork() {
		return network;
	}

	public List<Dependency> getDependencies() {
		return dependencies;
	}

	public boolean getHasQa() {
		return hasQa;
	}

	public boolean getUseAndroidX() {
		return useAndroidX;
	}

	public boolean getHasOneSignal() {
		return hasOneSignal;
	}

	public String getSlackChannel() {
		return slackChannel;
	}

	public String getTestFairyKey() {
		return testFairyKey;
	}

	public String getKotlinVersion() {
		return kotlinVersion;
	}

	public String getSlackSlug() {
		return slackSlug;
	}
}
