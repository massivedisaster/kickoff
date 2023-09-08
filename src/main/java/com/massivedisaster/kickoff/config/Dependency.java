package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;

public class Dependency {

    @JsonProperty("name")
    private String name;
    @JsonProperty("globalVersion")
    private String globalVersion;
    @JsonProperty("list")
    private HashMap<String, LibraryModule> list;

    public String getName() {
        return name;
    }

    public String getGlobalVersion() {
        return globalVersion;
    }

    public HashMap<String, LibraryModule> getList() {
        return list;
    }
}
