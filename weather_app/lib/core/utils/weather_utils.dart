import 'package:intl/intl.dart';
import 'package:weather_app/presentation/widgets/weather_background.dart';
 
class WeatherUtils {
  static WeatherType getWeatherTypeFromCondition(int conditionId) {
    if (conditionId >= 200 && conditionId < 300) {
      return WeatherType.thunderstorm;
    } else if (conditionId >= 300 && conditionId < 600) {
      return WeatherType.rain;
    } else if (conditionId >= 600 && conditionId < 700) {
      return WeatherType.snow;
    } else if (conditionId >= 700 && conditionId < 800) {
      return WeatherType.mist;
    } else if (conditionId == 800) {
      return WeatherType.clear;
    } else if (conditionId > 800 && conditionId < 900) {
      return WeatherType.clouds;
    } else {
      return WeatherType.unknown;
    }
  }

  static bool isDayTime(DateTime? dateTime) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    return hour >= 6 && hour < 18;
  }

  static String getWeatherIconPath(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  static String formatTemperature(double temp) {
    return '${temp.toStringAsFixed(1)}°C';
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Tomorrow';
    return DateFormat('EEE').format(date);
  }

  static String getWeatherAnimationAsset(WeatherType type, bool isDay) {
    switch (type) {
      case WeatherType.clear:
        return isDay ? 'sunny' : 'night';
      case WeatherType.clouds:
        return 'cloudy';
      case WeatherType.rain:
        return 'rainy';
      case WeatherType.thunderstorm:
        return 'storm';
      case WeatherType.snow:
        return 'snow';
      case WeatherType.mist:
        return 'fog';
      default:
        return 'default';
    }
  }
}