import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather_forecast_entity.dart';
import '../../core/constants/app_constants.dart';

class ForecastCard extends StatelessWidget {
  final WeatherForecastEntity forecast;
  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            '7-DAY FORECAST',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          ...forecast.dailyForecasts
              .take(7)
              .toList()
              .asMap()
              .entries
              .map((e) => _buildRow(e.value, e.key == 0)),
        ],
      ),
    );
  }

  Widget _buildRow(DailyForecast daily, bool isToday) {
    // Temp range bar: position fill relative to a assumed daily range
    // We normalise across a rough -5 to 40°C scale
    const double scaleMin = -5;
    const double scaleMax = 40;
    final double leftFrac =
        ((daily.minTemp - scaleMin) / (scaleMax - scaleMin)).clamp(0.0, 1.0);
    final double rightFrac =
        1 - ((daily.maxTemp - scaleMin) / (scaleMax - scaleMin)).clamp(0.0, 1.0);

    final dayLabel = isToday
        ? 'Today'
        : DateFormat('EEE').format(daily.date);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            // Day name
            SizedBox(
              width: 72,
              child: Text(
                dayLabel,
                style: TextStyle(
                  color: isToday ? Colors.white : Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

            // Weather icon
            SizedBox(
              width: 36,
              height: 36,
              child: Image.network(
                '${AppConstants.weatherIconUrl}/${daily.iconCode}@2x.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.cloud, color: Colors.white70, size: 24),
              ),
            ),

            const SizedBox(width: 10),

            // Temp range bar + precipitation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bar track
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1.0,
                      child: LayoutBuilder(builder: (ctx, constraints) {
                        return Stack(children: [
                          Positioned.fill(
                            left: constraints.maxWidth * leftFrac,
                            right: constraints.maxWidth * rightFrac,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4fc3f7), Color(0xFFffb74d)],
                                ),
                              ),
                            ),
                          ),
                        ]);
                      }),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Precipitation probability
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop_rounded,
                        size: 10,
                        color: daily.pop > 0.3
                            ? const Color(0xFF4fc3f7)
                            : Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${(daily.pop * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          color: daily.pop > 0.3
                              ? const Color(0xFF4fc3f7)
                              : Colors.white.withOpacity(0.35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Max / min temps
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${daily.maxTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${daily.minTemp.toStringAsFixed(0)}°',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}