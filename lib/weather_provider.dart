import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'weather_data.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final _service = WeatherService();

  WeatherStatus status = WeatherStatus.initial;
  WeatherData? weather;
  List<ForecastItem> forecast = [];
  String errorMessage = '';
  CancelToken _token = CancelToken();

  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    _token.cancel(); // Cancel any running request
    _token = CancelToken();

    status = WeatherStatus.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getWeather(city, token: _token),
        _service.getForecast(city, token: _token),
      ]);
      weather = results[0] as WeatherData;
      forecast = results[1] as List<ForecastItem>;
      status = WeatherStatus.success;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) return;
      errorMessage = e is DioException ? e.error.toString() : 'Something went wrong.';
      status = WeatherStatus.error;
    }
    notifyListeners();
  }
}