import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../../core/constants/app_constants.dart';

class WeatherCard extends StatelessWidget {
  final WeatherEntity weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.22),
                  Colors.white.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: location + time ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.near_me_rounded,
                            color: Colors.white70, size: 13),
                        const SizedBox(width: 6),
                        Text(
                          weather.locationName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Temp + icon side by side ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        '${AppConstants.weatherIconUrl}/${weather.iconCode}@2x.png',
                        width: 72,
                        height: 72,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.white70,
                          size: 56,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Description ──
                Text(
                  weather.description.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Divider ──
                Divider(color: Colors.white.withOpacity(0.12), height: 1),

                const SizedBox(height: 20),

                // ── 4-metric grid ──
                Row(
                  children: [
                    _buildMetric(Icons.water_drop_rounded,
                        '${weather.humidity}%', 'HUMIDITY'),
                    const SizedBox(width: 8),
                    _buildMetric(Icons.air_rounded,
                        '${weather.windSpeed.toStringAsFixed(1)}m/s', 'WIND'),
                    const SizedBox(width: 8),
                    _buildMetric(Icons.thermostat_rounded,
                        '${weather.feelsLike.toInt()}°', 'FEELS'),
                    const SizedBox(width: 8),
                    _buildMetric(Icons.speed_rounded,
                        '${weather.pressure}', 'PRESSURE'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}