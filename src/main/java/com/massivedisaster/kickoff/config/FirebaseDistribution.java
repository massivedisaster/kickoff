package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class FirebaseDistribution {
    @JsonProperty("ids")
    private FirebaseIds ids;
    @JsonProperty("groups")
    private List<String> groups;
    public FirebaseIds getIds() {
        return ids;
    }
    public List<String> getGroups() {
        return groups;
    }
}
