package com.massivedisaster.kickoff.config;

public class OnesignalConfiguration {

	private OnesignalEnvironment prod;
	private OnesignalEnvironment dev;
	private OnesignalEnvironment qa;
	
	public OnesignalEnvironment getProd() {
		return prod;
	}
	
	public OnesignalEnvironment getDev() {
		return dev;
	}
	
	public OnesignalEnvironment getQa() {
		return qa;
	}
}
