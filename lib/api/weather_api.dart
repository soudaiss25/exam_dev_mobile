import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather_data.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://api.weatherapi.com/v1")
abstract class WeatherApiClient {
  factory WeatherApiClient(Dio dio, {String baseUrl}) = _WeatherApiClient;

  @GET("/current.json")
  Future<WeatherApiResponse> getCurrentWeather(
      @Query("key") String apiKey,
      @Query("q") String city,
      );
}