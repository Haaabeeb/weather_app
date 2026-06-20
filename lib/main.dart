import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'weather_widgets.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => WeatherProvider(),
    child: const MaterialApp(debugShowCheckedModeBanner: false, home: WeatherScreen()),
  ),
);

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _controller = TextEditingController();

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().fetchWeather(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Enter city name...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white54)),
          onSubmitted: (_) => _search(),
        ),
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _search)],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, _) {
          switch (provider.status) {
            case WeatherStatus.initial: return const Center(child: Text('Search for a city', style: TextStyle(color: Colors.white54)));
            case WeatherStatus.loading: return const WeatherLoadingSpinner();
            case WeatherStatus.error: return WeatherErrorWidget(msg: provider.errorMessage, onRetry: _search);
            case WeatherStatus.success: return ListView(
              padding: const EdgeInsets.all(20),
              children: [WeatherCard(weather: provider.weather!), const SizedBox(height: 24), ForecastRow(items: provider.forecast)],
            );
          }
        },
      ),
    );
  }
}