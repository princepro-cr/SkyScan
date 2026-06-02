import 'dart:ui';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/weather_background.dart';
import '../../core/utils/weather_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchWeather());
  }

  Future<void> _fetchWeather() async {
    await context.read<WeatherProvider>().fetchWeatherByCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final weather = weatherProvider.weather;
        final weatherType = weather != null
            ? WeatherUtils.getWeatherTypeFromCondition(weather.conditionId ?? 800)
            : WeatherType.clear;
        final isDay = WeatherUtils.isDayTime(DateTime.now());

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // 1. Dynamic Background Layer
              WeatherBackground(
                weatherType: weatherType,
                isDay: isDay,
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),

              // 2. Content Layer
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildGlassAppBar(),
                  SliverToBoxAdapter(
                    child: _buildMainContent(weatherProvider, weatherType),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SKYSCAN',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: _fetchWeather,
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(WeatherProvider provider, WeatherType type) {
    if (provider.isLoading) return const LoadingWidget();
    if (provider.errorMessage != null) {
      return ErrorWidget(
        message: provider.errorMessage!,
        onRetry: _fetchWeather,
      );
    }
    if (provider.weather == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 72, // status bar + app bar height
        bottom: MediaQuery.of(context).padding.bottom + 40,
      ),
      child: Column(
        children: [
          WeatherCard(weather: provider.weather!),
          const SizedBox(height: 24),
          if (provider.forecast != null)
            ForecastCard(forecast: provider.forecast!),
          const SizedBox(height: 32),
          Text(
            _getWeatherQuote(type),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
              letterSpacing: 1.1,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getWeatherQuote(WeatherType type) {
    switch (type) {
      case WeatherType.clear:
        return "Clear skies, clear mind.";
      case WeatherType.clouds:
        return "Every cloud has a silver lining.";
      case WeatherType.rain:
        return "Let the rain wash away the worries.";
      case WeatherType.thunderstorm:
        return "After the storm comes the calm.";
      case WeatherType.snow:
        return "Every snowflake is a kiss from the sky.";
      case WeatherType.mist:
        return "Mystery lives in the mist.";
      default:
        return "Nature is never in a hurry, yet everything is accomplished.";
    }
  }
}