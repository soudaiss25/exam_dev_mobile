import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

// Modèle pour la réponse complète de l'API
@JsonSerializable()
class WeatherApiResponse {
  final LocationData location;
  final CurrentData current;

  WeatherApiResponse({
    required this.location,
    required this.current,
  });

  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherApiResponseToJson(this);
}

@JsonSerializable()
class LocationData {
  final String name;

  LocationData({required this.name});

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}

@JsonSerializable()
class CurrentData {
  @JsonKey(name: 'temp_c')
  final double tempC;
  final ConditionData condition;
  final int humidity;
  @JsonKey(name: 'wind_kph')
  final double windKph;

  CurrentData({
    required this.tempC,
    required this.condition,
    required this.humidity,
    required this.windKph,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) =>
      _$CurrentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentDataToJson(this);
}

@JsonSerializable()
class ConditionData {
  final String text;

  ConditionData({required this.text});

  factory ConditionData.fromJson(Map<String, dynamic> json) =>
      _$ConditionDataFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionDataToJson(this);
}

// Votre classe WeatherData actuelle
class WeatherData {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  // Créer WeatherData à partir de la réponse API
  factory WeatherData.fromApiResponse(WeatherApiResponse response) {
    return WeatherData(
      city: response.location.name,
      temperature: response.current.tempC,
      condition: response.current.condition.text,
      humidity: response.current.humidity,
      windSpeed: response.current.windKph,
    );
  }
}