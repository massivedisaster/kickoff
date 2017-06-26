package com.massivedisaster.kickoff.network;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Url;

public interface KickoffService {

    @GET
    Call<ResponseBody> downloadTemplate(@Url String url);
}
