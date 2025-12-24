import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final String description;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.weatherCode,
  });
}

class WeatherService {
  // Coordinates for Bolívar, Buenos Aires
  static const double _latitude = -36.2303;
  static const double _longitude = -61.1138;

  /// Fetches current weather data from Open-Meteo API
  Future<WeatherData?> fetchWeather() async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$_latitude&longitude=$_longitude&current_weather=true',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current_weather'];
        final int weatherCode = current['weathercode'];

        return WeatherData(
          temperature: current['temperature'],
          description: getWeatherDescription(weatherCode),
          weatherCode: weatherCode,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Converts weather code to Spanish description
  String getWeatherDescription(int code) {
    if (code == 0) return 'Despejado';
    if (code >= 1 && code <= 3) return 'Parcialmente Nublado';
    if (code >= 45 && code <= 48) return 'Niebla';
    if (code >= 51 && code <= 67) return 'Llovizna';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Lluvia Fuerte';
    if (code >= 95) return 'Tormenta';
    return 'Variable';
  }
}
