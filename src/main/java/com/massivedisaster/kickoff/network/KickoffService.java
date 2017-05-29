package com.massivedisaster.kickoff.network;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface KickoffService {

    @GET("raw/master/templates/{language}/{projectType}.tar.gz")
    Call<ResponseBody> downloadTemplate(@Path("language") String language, @Path("projectType") String projectType);

}
