import 'dart:ui';
import 'package:flutter/material.dart';
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
  bool _searchOpen = false;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchLocation());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    await context
        .read<WeatherProvider>()
        .fetchWeatherByCurrentLocation();
  }

  void _openSearch() {
    setState(() => _searchOpen = true);
    Future.delayed(
      const Duration(milliseconds: 80),
      () => _searchFocus.requestFocus(),
    );
  }

  void _closeSearch() {
    setState(() {
      _searchOpen = false;
      _searchController.clear();
    });
    _searchFocus.unfocus();
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _closeSearch();
      return;
    }
    context.read<WeatherProvider>().fetchWeatherByCity(query);
    _closeSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final weather = provider.weather;
        final weatherType = weather != null
            ? WeatherUtils.getWeatherTypeFromCondition(
                weather.conditionId ?? 800)
            : WeatherType.clear;
        final isDay = WeatherUtils.isDayTime(DateTime.now());

        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              WeatherBackground(
                weatherType: weatherType,
                isDay: isDay,
                child: Container(
                    color: Colors.black.withOpacity(0.1)),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(provider),
                  SliverToBoxAdapter(
                    child: _buildMainContent(
                        provider, weatherType),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(WeatherProvider provider) {
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.white24),
              ),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _searchOpen
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                // ── Default bar ──
                firstChild: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                    Row(
                      children: [
                        // Back to location button
                        // (only shown when viewing a searched city)
                        if (provider.isShowingCity)
                          GestureDetector(
                            onTap: _fetchLocation,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 14),
                              child: Icon(
                                Icons.near_me_rounded,
                                color: Colors.white
                                    .withOpacity(0.7),
                                size: 18,
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: _openSearch,
                          child: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: provider.isShowingCity
                              ? _fetchLocation
                              : _fetchLocation,
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // ── Search bar ──
                secondChild: Row(
                  children: [
                    GestureDetector(
                      onTap: _closeSearch,
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white70, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onSubmitted: (_) => _submitSearch(),
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search city...',
                          hintStyle: TextStyle(
                            color: Colors.white
                                .withOpacity(0.35),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: Colors.white,
                        cursorWidth: 1.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: _submitSearch,
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white70, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      WeatherProvider provider, WeatherType type) {
    if (provider.isLoading) return const LoadingWidget();
    // if (provider.errorMessage != null) {
    //   return ErrorWidget(
    //     message: provider.errorMessage!,
    //     onRetry: _fetchLocation,
    //   );
    // }
    if (provider.weather == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 72,
        bottom:
            MediaQuery.of(context).padding.bottom + 40,
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