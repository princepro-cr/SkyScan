import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/api_constants.dart';
import '../../core/exceptions/weather_exceptions.dart';
import '../../data/models/weather_model.dart';
import '../../data/models/weather_forecast_model.dart';

class WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSource({required this.client});

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw WeatherException('API key is not configured');
      }

      final url = Uri.parse(
        '${AppConstants.openWeatherBaseUrl}${ApiConstants.currentWeather}?lat=$lat&lon=$lon&appid=$apiKey',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key');
      } else if (response.statusCode == 404) {
        throw WeatherException('Location not found');
      } else {
        throw WeatherException('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: $e');
    }
  }

  Future<WeatherForecastModel> getWeatherForecastByLocation(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw WeatherException('API key is not configured');
      }

      final url = Uri.parse(
        '${AppConstants.openWeatherBaseUrl}${ApiConstants.forecast}?lat=$lat&lon=$lon&appid=$apiKey',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        return WeatherForecastModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key');
      } else if (response.statusCode == 404) {
        throw WeatherException('Location not found');
      } else {
        throw WeatherException('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: $e');
    }
  }
}