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

  // tracks whether we're showing a searched city or current location
  bool _isShowingCity = false;
  bool get isShowingCity => _isShowingCity;

  Future<void> fetchWeatherByCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    _isShowingCity = false;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();
      _weather = await weatherRepository.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      await _fetchForecastByCoords(position.latitude, position.longitude);
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

  Future<void> fetchWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await weatherRepository.getWeatherByCity(cityName.trim());
      await _fetchForecastByCity(cityName.trim());
      _isShowingCity = true;
    } on WeatherException catch (e) {
      _errorMessage = e.toString();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchForecastByCoords(double lat, double lon) async {
    try {
      _forecast = await weatherRepository.getWeatherForecastByLocation(
          lat, lon);
    } catch (e) {
      if (kDebugMode) print('Forecast fetch failed: $e');
    }
  }

  Future<void> _fetchForecastByCity(String cityName) async {
    try {
      _forecast =
          await weatherRepository.getWeatherForecastByCity(cityName);
    } catch (e) {
      if (kDebugMode) print('Forecast fetch failed: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}