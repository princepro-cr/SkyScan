import 'package:flutter/foundation.dart';
import 'package:weather_app/domain/entities/repositories/weather_repository.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/weather_forecast_entity.dart';
 import '../../core/exceptions/weather_exceptions.dart';
import '../../core/utils/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepository weatherRepository;
  final LocationService locationService;

  WeatherProvider({
    required this.weatherRepository,
    required this.locationService,
  });

  WeatherEntity? _weather;
  WeatherEntity? get weather => _weather;

  WeatherForecastEntity? _forecast;
  WeatherForecastEntity? get forecast => _forecast;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeatherByCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();
      
      final weatherData = await weatherRepository.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      
      _weather = weatherData;
      
      await _fetchForecast(position.latitude, position.longitude);
      
    } on LocationException catch (e) {
      _errorMessage = e.toString();
    } on WeatherException catch (e) {
      _errorMessage = e.toString();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchForecast(double lat, double lon) async {
    try {
      final forecastData = await weatherRepository.getWeatherForecastByLocation(lat, lon);
      _forecast = forecastData;
    } catch (e) {
      if (kDebugMode) {
        print('Forecast fetch failed: $e');
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}