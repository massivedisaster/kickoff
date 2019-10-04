package com.massivedisaster.kickoff.config;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;

public class Network {

	@JsonProperty("timeout")
	private int timeout;
	@JsonProperty("endpoints")
	private HashMap<String, String> endpoints;

	public int getTimeout() {
		return timeout;
	}

	public HashMap<String, String> getEndpoints() {
		return endpoints;
	}
}
