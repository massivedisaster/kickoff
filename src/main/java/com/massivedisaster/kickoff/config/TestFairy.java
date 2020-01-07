package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class TestFairy {
    @JsonProperty("key")
    private String key;
    @JsonProperty("groups")
    private List<String> groups;
    public String getKey() {
        return key;
    }
    public List<String> getGroups() {
        return groups;
    }
}
