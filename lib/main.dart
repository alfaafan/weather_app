import 'package:flutter/material.dart';
import 'package:weather_app/app/pages/weather_screen/weather_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // await DotenvConfig.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}
