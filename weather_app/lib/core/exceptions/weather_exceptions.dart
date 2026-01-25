class WeatherException implements Exception {
  final String message;
  
  WeatherException(this.message);
  
  @override
  String toString() => 'WeatherException: $message';
}

class LocationException implements Exception {
  final String message;
  
  LocationException(this.message);
  
  @override
  String toString() => 'LocationException: $message';
}