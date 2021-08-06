package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class FirebaseIds {
    @JsonProperty("dev")
    private String dev;
    @JsonProperty("prod")
    private String prod;
    @JsonProperty("qa")
    private String qa;
    public String getDev() {
        return dev;
    }
    public String getProd() {
        return prod;
    }
    public String getQa() {
        return qa;
    }
}
