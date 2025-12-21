import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  double? _temperature;
  String? _weatherCodeString;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      // Coords for Bolívar, Buenos Aires: -36.2303, -61.1138
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=-36.2303&longitude=-61.1138&current_weather=true',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current_weather'];
        setState(() {
          _temperature = current['temperature'];
          _weatherCodeString = _getWeatherDescription(current['weathercode']);
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

  String _getWeatherDescription(int code) {
    if (code == 0) return 'Despejado';
    if (code >= 1 && code <= 3) return 'Parcialmente Nublado';
    if (code >= 45 && code <= 48) return 'Niebla';
    if (code >= 51 && code <= 67) return 'Llovizna';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Lluvia Fuerte';
    if (code >= 95) return 'Tormenta';
    return 'Variable';
  }

  IconData _getWeatherIcon(String? description) {
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
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
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
                        '${_temperature?.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _weatherCodeString ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _getWeatherIcon(_weatherCodeString),
                    size: 48,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
      ),
    );
  }
}
