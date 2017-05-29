package ${configs.packageName}.network;

import ${configs.packageName}.BuildConfig;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * The Retrofit Rest Client.
 */
public final class RetrofitAdapter {

    /**
     * Constructor, private constructor to prevent instantiation.
     */
    private RetrofitAdapter() {
    }

    /**
     * Instantiate a Retrofit object.
     * @return The Retrofit object.
     */
    public static Retrofit getRetrofit() {
        Gson gson = new GsonBuilder().create();

        return new Retrofit.Builder()
                .baseUrl(BuildConfig.API_BASE_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(getOkHttpClient(BuildConfig.API_TIMEOUT))
                .build();
    }

    /**
     * Instantiate a OkHttpClient object.
     * @param timeout The connection and reader timeout.
     * @return The OkHttpClient.
     */
    private static OkHttpClient getOkHttpClient(long timeout) {
        return new OkHttpClient.Builder()
                .readTimeout(timeout, TimeUnit.SECONDS)
                .connectTimeout(timeout, TimeUnit.SECONDS)
                .addNetworkInterceptor(new HttpLoggingInterceptor().setLevel(
                       BuildConfig.DEBUG ? HttpLoggingInterceptor.Level.BODY : HttpLoggingInterceptor.Level.BASIC))
                .build();
    }
}
