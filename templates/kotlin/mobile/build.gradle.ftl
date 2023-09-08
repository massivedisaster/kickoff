buildscript {
    ext.kotlin_version = '${configs.kotlinVersion}'
    ext.android_version = '${configs.gradlePluginVersion}'
    dependencies {
<#if configs.hasFirebase!true>
    <#if configs.firebase.classpaths??>
        <#list configs.firebase.classpaths as dependency>
        classpath '${dependency.group}:${dependency.version}'
        </#list>
    </#if>
</#if>
    }
}

// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version "$android_version" apply false
    id 'com.android.library' version "$android_version" apply false
    id 'org.jetbrains.kotlin.android' version "$kotlin_version" apply false
    id 'org.jetbrains.kotlin.kapt' version "$kotlin_version" apply false
<#if configs.hasDaggerHilt!true>
    id '${configs.daggerHilt.plugin}' version '${configs.daggerHilt.version}' apply false
</#if>
    id 'com.github.ben-manes.versions' version '${configs.benManesVersion}' apply true
    id 'org.ajoberstar.grgit' version '${configs.grGitVersion}' apply true
}
