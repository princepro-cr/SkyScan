class WeatherEntity {
  final String locationName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final String description;
  final String iconCode;
  final double windSpeed;
  final int? conditionId;

  const WeatherEntity({
    required this.locationName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.windSpeed,
    this.conditionId,
  });
}