import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _weather = 'Loading...';
  late double _latitude;
  late double _longitude;
  late String _city;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetch();
  }

  Future<void> _checkPermissionAndFetch() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _updateWeather();
    } else {
      setState(() {
        _weather = 'Location permission not granted.';
      });
    }
  }

  Future<void> _updateWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=c36d00a1ade6f97e5f7d9861c3dff92c'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String weather = data['weather'][0]['description'];
      setState(() {
        _weather = weather;
        _latitude = position.latitude;
        _longitude = position.longitude;
        _city = 'Surakarta';
      });
    } else {
      setState(() {
        _weather = 'Failed to load weather data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Current weather: $_weather',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Latitude: $_latitude',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Longitude: $_longitude',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'City: $_city',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissionAndFetch,
              child: const Text('Update Weather'),
            ),
          ],
        ));
  }
}
