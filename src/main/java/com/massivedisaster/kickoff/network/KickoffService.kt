package com.massivedisaster.kickoff.network

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Url

interface KickoffService {
    @GET
    fun downloadTemplate(@Url url: String): Call<ResponseBody>
}