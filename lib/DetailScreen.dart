import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key, required this.city});
  final String city;
  late final api = MeteoApiService(city: city);
  // late Future<Map<String, double>> weather = api.fetchTasks();
  final Map<String,String> labels = {
    "temperature_2m": "Temperatura",
    "wind_speed_10m": "Predkosc_wiatru",
    "relative_humidity_2m": "Wilgotnosc",
    "pressure_msl": "Cisnienie",
    "cloud_cover": "Zachmurzenie",
    "rain": "Opady"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detale"),
      ),
      body: FutureBuilder<Map<String,double>>(
        future: api.fetchTasks(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final weather = snapshot.data!;

          return ListView(
            children: weather.entries.map((entry) {
              return ListTile(
                title: Text(labels[entry.key] ?? entry.key),
                subtitle: Text(entry.value.toString()),
              );
            }).toList(),
          );
        }
      ),
    );
  }
}
// children: weather.entries.map((entry) {
// return ListTile(
// title: Text(labels[entry.key] ?? entry.key),
// subtitle: Text(entry.value.toString()),
// );
// })
class PrintWeather {
  const PrintWeather({required this.temperature, required this.wind, required this.humidity, required this.pressure, required this.cloud, required this.rain});
  final double temperature;
  final double wind;
  final double humidity;
  final double pressure;
  final double cloud;
  final double rain;

}

class MeteoApiService {
  const MeteoApiService({required this.city});
  final String city;
  static const String baseUrl = "https://api.open-meteo.com/v1/forecast?";
  Future<Map<String,double>> fetchTasks() async {
    final response = await http.get(Uri.parse("$baseUrl$city&current=temperature_2m,wind_speed_10m,relative_humidity_2m,pressure_msl,cloud_cover,rain"),
    );
    if(response.statusCode == 200)
    {
      final data = jsonDecode(response.body);
      return data;
    }
    else
    {
      throw Exception("Blad pobierania danych");
    }
  }
}