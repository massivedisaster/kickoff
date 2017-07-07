package com.massivedisaster.kickoff.config;

public class Dependencies {

    private String fabrickey;
    private RetrofitConfiguration retrofit;
    private OnesignalConfiguration onesignal;

    public String getFabrickey() {
        return fabrickey;
    }

    public RetrofitConfiguration getRetrofit() {
        return retrofit;
    }

    public OnesignalConfiguration getOnesignal() {
        return onesignal;
    }
}
