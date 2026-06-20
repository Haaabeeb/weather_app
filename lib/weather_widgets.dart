import 'package:flutter/material.dart';
import 'weather_data.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text('${weather.cityName}, ${weather.country}',
        style: const TextStyle(fontSize: 24, color: Colors.white)),
    Image.network(weather.iconUrl),
    Text('${weather.temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 48, color: Colors.white)),
    Text(weather.description.toUpperCase(), style: const TextStyle(color: Colors.white70)),
    const SizedBox(height: 10),

    Text('Feels: ${weather.feelsLike}° | Humidity: ${weather.humidity}% | Wind: ${weather.windSpeed}m/s',
        style: const TextStyle(color: Colors.white54)),
  ]);
}

class WeatherLoadingSpinner extends StatelessWidget {
  const WeatherLoadingSpinner({super.key});
  @override Widget build(BuildContext context) => const Center(child: CircularProgressIndicator(color: Colors.white));
}

class WeatherErrorWidget extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const WeatherErrorWidget({super.key, required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Text(msg, style: const TextStyle(color: Colors.white)),
    TextButton(onPressed: onRetry, child: const Text('Try Again', style: TextStyle(color: Colors.blue)
    )
    ),
  ]));
}

class ForecastRow extends StatelessWidget {
  final List<ForecastItem> items;
  const ForecastRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Automatically spaces the 5 items evenly
    children: items.map((i) => Column(children: [
      Text(i.time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      Image.network(i.iconUrl, width: 40, height: 40),
      Text('${i.temperature.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white)),
    ])).toList(),
  );
}
