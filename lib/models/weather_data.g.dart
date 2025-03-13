// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherApiResponse _$WeatherApiResponseFromJson(Map<String, dynamic> json) =>
    WeatherApiResponse(
      location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
      current: CurrentData.fromJson(json['current'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherApiResponseToJson(WeatherApiResponse instance) =>
    <String, dynamic>{
      'location': instance.location,
      'current': instance.current,
    };

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

CurrentData _$CurrentDataFromJson(Map<String, dynamic> json) => CurrentData(
      tempC: (json['temp_c'] as num).toDouble(),
      condition:
          ConditionData.fromJson(json['condition'] as Map<String, dynamic>),
      humidity: (json['humidity'] as num).toInt(),
      windKph: (json['wind_kph'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentDataToJson(CurrentData instance) =>
    <String, dynamic>{
      'temp_c': instance.tempC,
      'condition': instance.condition,
      'humidity': instance.humidity,
      'wind_kph': instance.windKph,
    };

ConditionData _$ConditionDataFromJson(Map<String, dynamic> json) =>
    ConditionData(
      text: json['text'] as String,
    );

Map<String, dynamic> _$ConditionDataToJson(ConditionData instance) =>
    <String, dynamic>{
      'text': instance.text,
    };
