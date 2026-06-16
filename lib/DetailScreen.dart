import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.city});

  final String city;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final MeteoApiService api;
  late Future<Map<String, dynamic>> futureWeather;
  final Map<String, String> labels = {
    "temperature_2m": "Temperatura",
    "wind_speed_10m": "Predkosc_wiatru",
    "relative_humidity_2m": "Wilgotnosc",
    "pressure_msl": "Cisnienie",
    "cloud_cover": "Zachmurzenie",
    "rain": "Opady"
  };

  @override
  void initState() {
    super.initState();
    api = MeteoApiService(city: widget.city);
    futureWeather = api.fetchWeather();
  }

  void refresh() {
    setState(() {
      futureWeather = api.fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detale"),
      ),
      body: FutureBuilder<Map<String, dynamic >>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("Brak danych"));
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
      floatingActionButton: FloatingActionButton(
          onPressed: refresh,
          child: Icon(Icons.refresh),
      ),
    );
  }
}

// class PrintWeather {
//   const PrintWeather({required this.temperature, required this.wind, required this.humidity, required this.pressure, required this.cloud, required this.rain});
//   final double temperature;
//   final double wind;
//   final double humidity;
//   final double pressure;
//   final double cloud;
//   final double rain;
// }

class MeteoApiService {
  const MeteoApiService({required this.city});
  final String city;
  static const String baseUrl = "https://api.open-meteo.com/v1/forecast?";
  Future<Map<String,dynamic>> fetchWeather() async {
    final response = await http.get(Uri.parse("$baseUrl$city&current=temperature_2m,wind_speed_10m,relative_humidity_2m,pressure_msl,cloud_cover,rain"),
    );
    if(response.statusCode == 200)
    {
      final data = jsonDecode(response.body);
      return data["current"];
    }
    else
    {
      throw Exception("Blad pobierania danych");
    }
  }
}
