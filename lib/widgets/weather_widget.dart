import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/weather_service.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherService.fetchWeather();
      if (weatherData != null) {
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  IconData _getWeatherIcon(String description) {
    switch (description) {
      case 'Despejado':
        return Icons.wb_sunny;
      case 'Parcialmente Nublado':
        return Icons.cloud_queue;
      case 'Niebla':
        return Icons.foggy;
      case 'Llovizna':
      case 'Lluvia Fuerte':
        return Icons.umbrella;
      case 'Nieve':
        return Icons.ac_unit;
      case 'Tormenta':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      // Fallback UI or empty to not disrupt the home screen too much
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white38,
                highlightColor: Colors.white60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100, height: 14, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 60, height: 28, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 80, height: 16, color: Colors.white),
                      ],
                    ),
                    Container(width: 48, height: 48, color: Colors.white),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clima en Bolívar',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_weatherData?.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _weatherData?.description ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _getWeatherIcon(_weatherData?.description ?? 'Variable'),
                    size: 48,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
      ),
    );
  }
}
