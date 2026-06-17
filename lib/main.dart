import 'package:flutter/material.dart';

import 'DetailScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hive_flutter/hive_flutter.dart';

const String Berlin = "latitude=52.52,&longitude=13.41";
const String Krakow = "latitude=50.06,&longitude=19.94";
const String Londyn = "latitude=51.12,&longitude=0.12";
const String Paryz = "latitude=48.85,&longitude=2.35";
const String Rzym = "latitude=41.90,&longitude=12.49";
const String Praga = "latitude=50.07,&longitude=14.43";
const String Budapeszt = "latitude=47.49,&longitude=19.04";
const String Oslo = "latitude=59.91,&longitude=10.75";
const String Sztokholm = "latitude=59.33,&longitude=18.06";
const String Helsinki = "latitude=60.16,&longitude=24.93";

const cities = [
  ('Berlin', Berlin),
  ('Krakow', Krakow),
  ('Londyn', Londyn),
  ('Paryz', Paryz),
  ('Rzym', Rzym),
  ('Praga', Praga),
  ('Budapeszt', Budapeszt),
  ('Oslo', Oslo),
  ('Sztokholm', Sztokholm),
  ('Helsinki', Helsinki),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meteo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Meteo"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text("Wybierz miasto"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: cities.map((city) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(city: city.$2),
                  ),
                );
              },
              icon: const Icon(Icons.subject),
              label: Text(city.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
