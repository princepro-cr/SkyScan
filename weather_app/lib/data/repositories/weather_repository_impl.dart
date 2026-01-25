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
      final weatherModel = await remoteDataSource.getWeatherByLocation(lat, lon);
      return weatherModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherEntity> getWeatherByCity(String cityName) {
    throw UnimplementedError();
  }

  @override
  Future<WeatherForecastEntity> getWeatherForecastByLocation(double lat, double lon) async {
    try {
      final forecastModel = await remoteDataSource.getWeatherForecastByLocation(lat, lon);
      return forecastModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherForecastEntity> getWeatherForecastByCity(String cityName) {
    throw UnimplementedError();
  }
}