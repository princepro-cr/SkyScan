import 'package:flutter/material.dart';
import '../../domain/entities/weather_forecast_entity.dart';
import '../../core/constants/app_constants.dart';

class ForecastCard extends StatelessWidget {
  final WeatherForecastEntity forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '5-Day Forecast',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            Column(
              children: forecast.dailyForecasts.asMap().entries.map((entry) {
                final index = entry.key;
                final daily = entry.value;
                return _buildForecastItem(daily, index);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(DailyForecast daily, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              forecast.getFormattedDate(index),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Expanded(
            child: Image.network(
              '${AppConstants.weatherIconUrl}/${daily.iconCode}@2x.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getWeatherIcon(daily.iconCode),
                  size: 30,
                  color: Colors.blue,
                );
              },
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${daily.maxTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${daily.minTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: daily.pop > 0.1
                ? Row(
                    children: [
                      const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                      const SizedBox(width: 2),
                      Text(
                        '${(daily.pop * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    if (iconCode.contains('01')) return Icons.wb_sunny;
    if (iconCode.contains('02')) return Icons.wb_cloudy;
    if (iconCode.contains('03') || iconCode.contains('04')) return Icons.cloud;
    if (iconCode.contains('09') || iconCode.contains('10')) return Icons.grain;
    if (iconCode.contains('11')) return Icons.flash_on;
    if (iconCode.contains('13')) return Icons.ac_unit;
    if (iconCode.contains('50')) return Icons.blur_on;
    return Icons.wb_sunny;
  }
}