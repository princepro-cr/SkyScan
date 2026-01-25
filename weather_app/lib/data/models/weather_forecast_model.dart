import 'package:intl/intl.dart';
import '../../domain/entities/weather_forecast_entity.dart';

class WeatherForecastModel extends WeatherForecastEntity {
  WeatherForecastModel({
    required String locationName,
    required List<DailyForecast> dailyForecasts,
  }) : super(
          locationName: locationName,
          dailyForecasts: dailyForecasts,
        );

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final locationName = json['city']['name'] ?? 'Unknown Location';
    final List<dynamic> forecastList = json['list'] ?? [];
    final dailyForecasts = _groupForecastsByDay(forecastList);
    
    return WeatherForecastModel(
      locationName: locationName,
      dailyForecasts: dailyForecasts,
    );
  }

  static List<DailyForecast> _groupForecastsByDay(List<dynamic> forecasts) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var forecast in forecasts) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        forecast['dt'] * 1000,
      );
      final String dayKey = DateFormat('yyyy-MM-dd').format(date);
      
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add({
        'date': date,
        'temp': forecast['main']['temp'].toDouble(),
        'description': forecast['weather'][0]['description'],
        'icon': forecast['weather'][0]['icon'],
        'humidity': forecast['main']['humidity'],
        'windSpeed': forecast['wind']['speed'].toDouble(),
        'pop': (forecast['pop'] ?? 0.0).toDouble(),
      });
    }
    
    final List<DailyForecast> dailyForecasts = [];
    final keys = grouped.keys.toList()..sort();
    
    for (int i = 0; i < keys.length && i < 5; i++) {
      final dayKey = keys[i];
      final dayForecasts = grouped[dayKey]!;
      
      final temps = dayForecasts.map((f) => f['temp']).toList();
      final maxTemp = temps.reduce((a, b) => a > b ? a : b);
      final minTemp = temps.reduce((a, b) => a < b ? a : b);
      
      final modeDescription = _getModeDescription(dayForecasts);
      final modeIcon = _getModeIcon(dayForecasts);
      
      final avgHumidity = dayForecasts
          .map((f) => f['humidity'])
          .reduce((a, b) => a + b) ~/ dayForecasts.length;
          
      final avgWindSpeed = dayForecasts
          .map((f) => f['windSpeed'])
          .reduce((a, b) => a + b) / dayForecasts.length;
          
      final maxPop = dayForecasts
          .map((f) => f['pop'])
          .reduce((a, b) => a > b ? a : b);
      
      dailyForecasts.add(DailyForecast(
        date: dayForecasts.first['date'],
        maxTemp: (maxTemp - 273.15).toDouble(),
        minTemp: (minTemp - 273.15).toDouble(),
        description: modeDescription,
        iconCode: modeIcon,
        humidity: avgHumidity,
        windSpeed: avgWindSpeed,
        pop: maxPop,
      ));
    }
    
    return dailyForecasts;
  }

  static String _getModeDescription(List<Map<String, dynamic>> forecasts) {
    final counts = <String, int>{};
    for (var forecast in forecasts) {
      final desc = forecast['description'] as String;
      counts[desc] = (counts[desc] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  static String _getModeIcon(List<Map<String, dynamic>> forecasts) {
    final counts = <String, int>{};
    for (var forecast in forecasts) {
      final icon = forecast['icon'] as String;
      counts[icon] = (counts[icon] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}