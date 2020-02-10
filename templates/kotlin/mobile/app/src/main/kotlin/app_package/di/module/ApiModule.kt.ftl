package ${configs.packageName}.di.module

import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import ${configs.packageName}.BuildConfig
import ${configs.packageName}.network.ApiProvider
import ${configs.packageName}.network.EndpointCollection
import ${configs.packageName}.network.adapter.CallAdapterFactory
import dagger.Module
import dagger.Provides
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import ${configs.packageName}.utils.authentication.AccountUtils
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

@Module
class ApiModule {

    @Singleton
    @Provides
    fun providesCallAdapterFactory() = CallAdapterFactory()

    @Singleton
    @Provides
    fun providesHttpInterceptor(accountUtils: AccountUtils) = Interceptor {
        var requestBuilder = it.request().newBuilder()
        requestBuilder.header("Content-Type", "application/json")
        requestBuilder.header("Accept", "application/json")
        if (accountUtils.isLogged()) {
            requestBuilder.header("Authorization", "Bearer ${r"${accountUtils.getToken()}"}")
        }
        return@Interceptor it.proceed(requestBuilder.build())
    }

    @Provides
    @Singleton
    fun provideOkHttpClient(interceptor: Interceptor): OkHttpClient {
        val httpLoggingInterceptor = HttpLoggingInterceptor()
        httpLoggingInterceptor.level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.BASIC
        val client = OkHttpClient.Builder()
                .readTimeout(BuildConfig.API_TIMEOUT, TimeUnit.SECONDS)
                .connectTimeout(BuildConfig.API_TIMEOUT, TimeUnit.SECONDS)
                .addInterceptor(interceptor)
                .addNetworkInterceptor(httpLoggingInterceptor)

        return client.build()
    }

    @Singleton
    @Provides
    fun provideObjectMapper(): ObjectMapper {
        return jacksonObjectMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .configure(DeserializationFeature.FAIL_ON_IGNORED_PROPERTIES, false)
                .setSerializationInclusion(JsonInclude.Include.NON_NULL)
    }

    @Provides
    @Singleton
    fun provideRetrofit(callAdapterFactory: CallAdapterFactory, objectMapper: ObjectMapper, okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
                .baseUrl(BuildConfig.API_BASE_URL)
                .client(okHttpClient)
                .addConverterFactory(JacksonConverterFactory.create(objectMapper))
                .addCallAdapterFactory(callAdapterFactory)
                .build()
    }

    @Provides
    @Singleton
    fun provideEndpointCollection(retrofit: Retrofit): EndpointCollection = retrofit.create(EndpointCollection::class.java)

    @Provides
    fun providesApiProvider(service: EndpointCollection) = ApiProvider(service)

}
