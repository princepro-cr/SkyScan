import 'package:weather_app/domain/entities/repositories/weather_repository.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/weather_forecast_entity.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WeatherEntity> getWeatherByLocation(double lat, double lon) async {
    try {
      return await remoteDataSource.getWeatherByLocation(lat, lon);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherEntity> getWeatherByCity(String cityName) async {
    try {
      return await remoteDataSource.getWeatherByCity(cityName);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherForecastEntity> getWeatherForecastByLocation(
      double lat, double lon) async {
    try {
      return await remoteDataSource.getWeatherForecastByLocation(lat, lon);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherForecastEntity> getWeatherForecastByCity(
      String cityName) async {
    try {
      return await remoteDataSource.getWeatherForecastByCity(cityName);
    } catch (e) {
      rethrow;
    }
  }
}