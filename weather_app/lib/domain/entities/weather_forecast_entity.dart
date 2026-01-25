import 'package:intl/intl.dart';

class WeatherForecastEntity {
  final String locationName;
  final List<DailyForecast> dailyForecasts;

  const WeatherForecastEntity({
    required this.locationName,
    required this.dailyForecasts,
  });

  String getFormattedDate(int index) {
    if (index >= dailyForecasts.length) return '';
    final date = dailyForecasts[index].date;
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.year == today.year && 
        date.month == today.month && 
        date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && 
               date.month == tomorrow.month && 
               date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE').format(date);
    }
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final double pop; // Probability of precipitation (0-1)

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });
}