package com.massivedisaster.kickoff.config;

import java.util.List;

public class ProjectConfiguration {

	private String template;
	private String gradlePluginVersion;
	private String projectName;
	private String packageName;
	private String language;
	private int minimumSdkApi;
	private int targetSdkApi;
	private String buildTools;
	private String projectType;
	private boolean hasQa;
	private Dependencies dependencies;
	private QualityVerifier qualityVerifier;
	private List<DependencyExtra> dependenciesExtra;

	public String getTemplate() {
		return template;
	}

	public String getGradlePluginVersion() {
		return gradlePluginVersion;
	}

	public String getProjectName() {
		return projectName;
	}

	public String getPackageName() {
		return packageName;
	}

	public String getLanguage() {
		return language;
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

	public String getProjectType() {
		return projectType;
	}

	public boolean isHasQa() {
		return hasQa;
	}

	public Dependencies getDependencies() {
		return dependencies;
	}

	public QualityVerifier getQualityVerifier() {
		return qualityVerifier;
	}

	public List<DependencyExtra> getDependenciesExtra() {
		return dependenciesExtra;
	}
}
