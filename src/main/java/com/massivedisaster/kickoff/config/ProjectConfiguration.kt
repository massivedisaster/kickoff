package com.massivedisaster.kickoff.config

import com.fasterxml.jackson.annotation.JsonProperty

data class ProjectConfiguration(
    @JsonProperty("template") val template: String,
    @JsonProperty("language") val language: String,
    @JsonProperty("gradlePluginVersion") val gradlePluginVersion: String,
    @JsonProperty("projectName") val projectName: String,
    @JsonProperty("packageName") val packageName: String,
    @JsonProperty("minimumSdkApi") val minimumSdkApi: Int,
    @JsonProperty("targetSdkApi") val targetSdkApi: Int,
    @JsonProperty("gradleVersion") val gradleVersion: String,
    @JsonProperty("kotlinVersion") val kotlinVersion: String,
    @JsonProperty("benManesVersion") val benManesVersion: String,
    @JsonProperty("grGitVersion") val grGitVersion: String,
    @JsonProperty("network") val network: Network,
    @JsonProperty("manifestKeys") val manifestKeys: HashMap<String, HashMap<String, String>>?,
    @JsonProperty("extraBuildVars") val extraBuildVars: HashMap<String, HashMap<String, String>>?,
    @JsonProperty("dependencies") val dependencies: List<Dependency>,
    @JsonProperty("hasQa") val hasQa: Boolean,
    @JsonProperty("hasOneSignal") val hasOneSignal: Boolean,
    @JsonProperty("oneSignal") val oneSignal: OneSignal?,
    @JsonProperty("hasFirebase") val hasFirebase: Boolean,
    @JsonProperty("firebase") val firebase: Firebase?,
    @JsonProperty("hasDaggerHilt") val hasDaggerHilt: Boolean,
    @JsonProperty("daggerHilt") val daggerHilt: DaggerHilt?
)

data class Network(
    @JsonProperty("timeout") val timeout: Int,
    @JsonProperty("endpoints") val endpoints: HashMap<String, String>
)

data class Dependency(
    @JsonProperty("name") val name: String,
    @JsonProperty("globalVersion") val globalVersion: String,
    @JsonProperty("list") val list: HashMap<String, LibraryModule>
)

data class LibraryModule(
    @JsonProperty("group") val group: String,
    @JsonProperty("version") val version: String?,
    @JsonProperty("isCompiler") val compiler: Boolean
)

data class OneSignal(
    @JsonProperty("version") val version: String,
    @JsonProperty("dependencies") val dependencies: HashMap<String, LibraryModule>
)

data class Firebase(
    @JsonProperty("version") val version: String,
    @JsonProperty("distribution") val distribution: Distribution,
    @JsonProperty("classpaths") val classpaths: List<LibraryModule>,
    @JsonProperty("dependencies") val dependencies: HashMap<String, String>
)

data class Distribution(
    @JsonProperty("ids") val ids: HashMap<String, String>,
    @JsonProperty("groups") val groups: List<String>
)

data class DaggerHilt(
    @JsonProperty("version") val version: String,
    @JsonProperty("plugin") val plugin: String,
    @JsonProperty("dependencies") val dependencies: HashMap<String, LibraryModule>
)
