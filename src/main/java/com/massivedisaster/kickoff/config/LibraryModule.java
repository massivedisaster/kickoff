package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

public class LibraryModule {

    @JsonProperty("group")
    private String group;
    @JsonProperty("version")
    private String version;
    @JsonProperty("isCompiler")
    private boolean isCompiler;

    public String getGroup() {
        return group;
    }

    public String getVersion() {
        return version;
    }

    public boolean getIsCompiler() {
        return isCompiler;
    }

}
