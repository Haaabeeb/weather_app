import 'package:dio/dio.dart';
import 'dio_client.dart';

class WeatherData {
  final String cityName, country, description, iconCode;
  final double temperature, feelsLike, humidity, windSpeed;

  WeatherData.fromJson(Map<String, dynamic> json)
      : cityName = json['name'],
        country = json['sys']['country'],
        description = json['weather'][0]['description'],
        iconCode = json['weather'][0]['icon'],
        temperature = (json['main']['temp'] as num).toDouble(),
        feelsLike = (json['main']['feels_like'] as num).toDouble(),
        humidity = (json['main']['humidity'] as num).toDouble(),
        windSpeed = (json['wind']['speed'] as num).toDouble();

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
class ForecastItem {
  final String time, iconCode;
  final double temperature;

  ForecastItem.fromJson(Map<String, dynamic> json, int timezoneOffset)
      : time = _formatCityTime(json['dt'] as int, timezoneOffset),
        iconCode = json['weather'][0]['icon'],
        temperature = (json['main']['temp'] as num).toDouble();

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode.png';

  //  Calculate the exact time using 12-hour AM/PM format
  static String _formatCityTime(int timestamp, int offset) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch((timestamp + offset) * 1000, isUtc: true);

    int hour = dateTime.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert 24-hour to 12-hour format
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12; // Changes 0:00 to 12:00 AM and 12:00 to 12:00 PM

    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour12:$minute $amPm';
  }
}

class WeatherService {
  final _dio = createDioClient();

  Future<WeatherData> getWeather(String city, {CancelToken? token}) async {
    final res = await _dio.get('/weather', queryParameters: {'q': city}, cancelToken: token);
    return WeatherData.fromJson(res.data);
  }

  Future<List<ForecastItem>> getForecast(String city, {CancelToken? token}) async {
    final res = await _dio.get('/forecast', queryParameters: {'q': city, 'cnt': 6}, cancelToken: token);

    final int timezoneOffset = res.data['city']['timezone'];

    return (res.data['list'] as List)
        .map((i) => ForecastItem.fromJson(i, timezoneOffset))
        .toList();
  }

}
