import 'package:flutter/material.dart';
import 'package:weather_app/presentation/widgets/weather_animations.dart';

enum WeatherType {
  clear,
  clouds,
  rain,
  thunderstorm,
  snow,
  mist,
  unknown,
}

class WeatherBackground extends StatelessWidget {
  final WeatherType weatherType;
  final Widget child;
  final bool isDay;

  const WeatherBackground({
    super.key,
    required this.weatherType,
    required this.child,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getBackgroundDecoration(),
      child: Stack(
        children: [
          _buildWeatherAnimations(),
          child,
        ],
      ),
    );
  }

  BoxDecoration _getBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _getGradientColors(),
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (weatherType) {
      case WeatherType.clear:
        return isDay
            ? const [
                Color(0xFF1a6bb5), // deep sky blue top
                Color(0xFF2d9cdb), // mid azure
                Color(0xFFf5a623), // warm golden horizon
              ]
            : const [
                Color(0xFF0a0a1a), // near-black cosmic
                Color(0xFF0d1b3e), // deep navy
                Color(0xFF1a2a5e), // midnight blue horizon
              ];

      case WeatherType.clouds:
        return isDay
            ? const [
                Color(0xFF4a7fa5), // muted steel blue
                Color(0xFF7baabf), // soft cloud blue
                Color(0xFFc5d8e8), // pale overcast horizon
              ]
            : const [
                Color(0xFF1c2a38), // dark slate
                Color(0xFF2a3d50), // charcoal blue
                Color(0xFF3d5266), // dim horizon
              ];

      case WeatherType.rain:
        return isDay
            ? const [
                Color(0xFF2c4a6e), // rain-heavy blue-grey
                Color(0xFF3d6b8a), // mid storm blue
                Color(0xFF6a93a8), // diffused wet horizon
              ]
            : const [
                Color(0xFF0f1f30), // dark wet slate
                Color(0xFF1a2f42), // deep rain night
                Color(0xFF243d52), // cold horizon
              ];

      case WeatherType.thunderstorm:
        return isDay
            ? const [
                Color(0xFF1a1a2e), // near-black dramatic
                Color(0xFF2d2d44), // purple-grey storm
                Color(0xFF4a3f5c), // bruised violet horizon
              ]
            : const [
                Color(0xFF0d0d18), // void black
                Color(0xFF1a1428), // deep violet
                Color(0xFF2a1f3d), // dark purple horizon
              ];

      case WeatherType.snow:
        return isDay
            ? const [
                Color(0xFF8ab4cc), // soft winter sky
                Color(0xFFb8d4e8), // pale icy blue
                Color(0xFFe8f4fc), // white-grey horizon
              ]
            : const [
                Color(0xFF1a2a38), // deep cold night
                Color(0xFF2a3d52), // dark ice blue
                Color(0xFF3d5470), // cold horizon glow
              ];

      case WeatherType.mist:
        return isDay
            ? const [
                Color(0xFF6b7f8a), // muted foggy top
                Color(0xFF8fa3ad), // soft grey-blue mid
                Color(0xFFc2d0d8), // pale horizon
              ]
            : const [
                Color(0xFF1e2a32), // dark misty night
                Color(0xFF2d3d47), // cool charcoal
                Color(0xFF3d5060), // foggy horizon
              ];

      default:
        return isDay
            ? const [
                Color(0xFF1a6bb5),
                Color(0xFF2d9cdb),
                Color(0xFFf5a623),
              ]
            : const [
                Color(0xFF0a0a1a),
                Color(0xFF0d1b3e),
                Color(0xFF1a2a5e),
              ];
    }
  }

  Widget _buildWeatherAnimations() {
    switch (weatherType) {
      case WeatherType.clear:
        return isDay ? const SunAnimation() : const StarsAnimation();
      case WeatherType.clouds:
        return const CloudsAnimation();
      case WeatherType.rain:
        return const RainAnimation();
      case WeatherType.thunderstorm:
        return const ThunderstormAnimation();
      case WeatherType.snow:
        return const SnowAnimation();
      case WeatherType.mist:
        return const MistAnimation();
      default:
        return const SizedBox.shrink();
    }
  }
}