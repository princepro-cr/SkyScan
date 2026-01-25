import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeather();
    });
  }

  Future<void> _fetchWeather() async {
    await context.read<WeatherProvider>().fetchWeatherByCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const LoadingWidget();
          }

          if (weatherProvider.errorMessage != null) {
            final isLocationError = weatherProvider.errorMessage!.contains('Location') || 
                                    weatherProvider.errorMessage!.contains('location');
            
            return ErrorWidget(
              message: weatherProvider.errorMessage!,
              onRetry: _fetchWeather,
              isLocationError: isLocationError,
            );
          }

          if (weatherProvider.weather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No weather data available',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _fetchWeather,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Get Weather'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                WeatherCard(weather: weatherProvider.weather!),
                const SizedBox(height: 20),
                
                if (weatherProvider.forecast != null && 
                    weatherProvider.forecast!.dailyForecasts.isNotEmpty)
                  ForecastCard(forecast: weatherProvider.forecast!),
                
                if (weatherProvider.forecast == null || 
                    weatherProvider.forecast!.dailyForecasts.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Forecast data not available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _fetchWeather,
                            child: const Text('Retry Forecast'),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                const Text(
                  'Data provided by OpenWeather',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}