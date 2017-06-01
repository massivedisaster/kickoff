package com.massivedisaster.kickoff.config;

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
	private String fabrickey;
	private RetrofitConfiguration retrofit;
	private OnesignalConfiguration onesignal;
	private QualityVerifier qualityVerifier;

	public String getTemplate() {
		return template;
	}

	public String getLanguage(){
		return language;
	}

	public String getProjectName(){
		return projectName;
	}
	
	public String getProjectType(){
		return projectType;
	}
	
	public String getPackageName(){
		return packageName;
	}

	public String getGradlePluginVersion() {
		return gradlePluginVersion;
	}

	public String getFabrickey() {
		return fabrickey;
	}

	public int getTargetSdkApi() {
		return targetSdkApi;
	}

	public int getMinimumSdkApi() {
		return minimumSdkApi;
	}

	public boolean isHasQa() {
		return hasQa;
	}

	public RetrofitConfiguration getRetrofit() {
		return retrofit;
	}

	public String getBuildTools() {
		return buildTools;
	}

	public OnesignalConfiguration getOnesignal() {
		return onesignal;
	}

	public QualityVerifier getQualityVerifier() {
		return qualityVerifier;
	}
}
