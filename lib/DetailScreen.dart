import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';




class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.city});

  final String city;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Box box;
  Future<Map<String, dynamic>>? futureWeather;
  MeteoApiService? api;
  final Map<String, String> labels = {
    "temperature_2m": "Temperatura",
    "wind_speed_10m": "Predkosc_wiatru",
    "relative_humidity_2m": "Wilgotnosc",
    "pressure_msl": "Cisnienie",
    "cloud_cover": "Zachmurzenie",
    "rain": "Opady"
  };
  final Map<String, String> units = {
    "temperature_2m": "C",
    "wind_speed_10m": "Km/h",
    "relative_humidity_2m": "%",
    "pressure_msl": "Hpa",
    "cloud_cover": "%",
    "rain": "mm"
  };

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    box = await Hive.openBox('weatherBox');
    api = MeteoApiService(city: widget.city, box: box);
    if(api != null) {
      futureWeather = api!.fetchWeather();
    }
    setState(() {});
  }

  void refresh() {
    setState(() {
      if(api != null) {
        futureWeather = api!.fetchWeather();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (futureWeather == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  subtitle: units[entry.key] != null
                  ? Text("${entry.value.toString()} ${units[entry.key]}")
                  : Text(entry.value.toString())
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
  const MeteoApiService({required this.city, required this.box});
  final String city;
  final Box box;
  static const String baseUrl = "https://api.open-meteo.com/v1/forecast?";
  Future<Map<String,dynamic>> fetchWeather() async {
    try{
      final response = await http.get(Uri.parse("$baseUrl$city&current=temperature_2m,wind_speed_10m,relative_humidity_2m,pressure_msl,cloud_cover,rain"),
      );
      if(response.statusCode == 200)
      {
        final data = jsonDecode(response.body);
        box.put(city, data["current"]);
        return data["current"];
      }
      else
      {
        throw Exception("Blad pobierania danych");
      }
    } catch(e) {
      final catched = box.get(city);

      if(catched != null)
      {
        return Map<String, dynamic>.from(catched);
      }

      throw Exception("Brak internetu i danych online");
    }
  }
}
