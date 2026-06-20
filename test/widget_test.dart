import 'package:flutter/material.dart';
import 'package:flutter_app_weather/main.dart';
import 'package:flutter_app_weather/weather_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('Weather App initial state test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherProvider(),
        child: const MaterialApp(home: WeatherScreen()),
      ),
    );

    // Verify initial prompt
    expect(find.text('Search for a city'), findsOneWidget);

    // Verify search field exists in the AppBar
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Enter city name...'), findsOneWidget);

    // Verify search button icon exists in the AppBar
    expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
  });

  // ─── NEW TEST: Verifying the Loading State ──────────────────────────────
  testWidgets('Weather App shows loading spinner', (WidgetTester tester) async {
    // 1. Create a provider and manually force it into the loading state
    final provider = WeatherProvider();
    provider.status = WeatherStatus.loading;

    // 2. Use ChangeNotifierProvider.value to inject our pre-configured provider
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: WeatherScreen()),
      ),
    );

    // 3. Verify the CircularProgressIndicator is on screen
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 4. Verify our specific loading text is present
    expect(find.text('Loading...'), findsOneWidget);

    // 5. Ensure the initial "Search for a city" text is gone
    expect(find.text('Search for a city'), findsNothing);
  });
}