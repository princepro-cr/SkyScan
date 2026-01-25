import '../../domain/entities/weather_entity.dart';
import 'dart:convert';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required String locationName,
    required double temperature,
    required double feelsLike,
    required int humidity,
    required int pressure,
    required String description,
    required String iconCode,
    required double windSpeed,
    int? conditionId,
  }) : super(
          locationName: locationName,
          temperature: temperature,
          feelsLike: feelsLike,
          humidity: humidity,
          pressure: pressure,
          description: description,
          iconCode: iconCode,
          windSpeed: windSpeed,
          conditionId: conditionId,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      locationName: json['name'] ?? 'Unknown Location',
      temperature: (json['main']['temp'] - 273.15).toDouble(),
      feelsLike: (json['main']['feels_like'] - 273.15).toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      windSpeed: (json['wind']['speed']).toDouble(),
      conditionId: json['weather'][0]['id'],
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'locationName': locationName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'description': description,
      'iconCode': iconCode,
      'windSpeed': windSpeed,
      'conditionId': conditionId,
    };
  }
}