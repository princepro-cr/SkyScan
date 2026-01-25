import 'package:weather_app/domain/entities/weather_entity.dart';
import 'package:weather_app/domain/entities/weather_forecast_entity.dart';
 
abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherByLocation(double lat, double lon);
  Future<WeatherEntity> getWeatherByCity(String cityName);
  Future<WeatherForecastEntity> getWeatherForecastByLocation(double lat, double lon);
  Future<WeatherForecastEntity> getWeatherForecastByCity(String cityName);
}