package com.massivedisaster.kickoff.config;

public class RetrofitConfiguration {

	private int timeout;
	private String qa;
	private String dev;
	private String prod;
	
	public int getTimeout() {
		return timeout;
	}

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
