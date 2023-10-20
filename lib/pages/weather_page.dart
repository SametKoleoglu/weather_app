import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_ornek/models/weather_model.dart';
import 'package:weather_app_ornek/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apiKey
  final _weatherService = WeatherService("c3c9df12031f4c9a40ce1eb0ff6d2427");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    //mevcut şehri al
    String currentCity = await _weatherService.getCurrentCity();

    //mevcut şehrin hava durumu
    try {
      final weather = await _weatherService.getWeather(currentCity);
      setState(() {
        _weather = weather;
      });
    }

    //hata olabilir
    catch (error) {
      print(error.toString());
    }
  }

  // animasyonlar
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/gunesli.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/bulutlu.json';
      case 'smoke':
      case 'haze':
      case 'mist':
      case 'dust':
      case 'fog':
        return 'assets/sisli.json';
      case 'rain':
        return 'assets/yagmurlu.json';
      case 'shower rain':
        return 'assets/saganakYagis.json';
      case 'thunderstorm':
        return 'assets/ruzgar.json';
      case 'clear':
        return 'assets/gunesli.json';
      default:
        return 'assets/default.json';
    }
  }

  @override
  void initState() {
    super.initState();

    //hava datasını çek
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Şehir adı
              Text(_weather?.cityName ?? "loading city..."),

              //animasyon
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              //Sıcaklık
              Text('${_weather?.temperature.round()}°C'),
              const SizedBox(
                height: 10,
              ),

              //Durum
              Text(_weather?.mainCondition ?? "")
            ],
          ),
        ));
  }
}
