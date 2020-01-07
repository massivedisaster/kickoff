package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Slack {
    @JsonProperty("channel")
    private String channel;
    @JsonProperty("slug")
    private String slug;
    public String getChannel() {
        return channel;
    }
    public String getSlug() {
        return slug;
    }
}
