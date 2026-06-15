import 'package:flutter/material.dart';

import 'DetailScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String Berlin = "latitude=52.52,&longitude=13.41";
const String Krakow = "latitude=50.06,&longitude=2.35";
const String Londyn = "latitude=51.12,&longitude=0.12";
const String Paryz = "latitude=48.85,&longitude=2.35";
const String Rzym = "latitude=41.90,&longitude=12.49";
const String Praga = "latitude=50.07,&longitude=14.43";
const String Budapeszt = "latitude=47.49,&longitude=19.04";
const String Oslo = "latitude=59.91,&longitude=10.75";
const String Sztokholm = "latitude=59.33,&longitude=18.06";
const String Helsinki = "latitude=60.16,&longitude=24.93";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Meteo"),
        ),
        body: Text("Hello"),
      ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
        ),
      ),
      floatingActionButton: Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute (
                  builder: (context) => DetailScreen(city: '$Berlin'),
                ),
              );
            },
            icon: const Icon(Icons.subject),
            label: const Text("Berlin")
          ),
          FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute (
                    builder: (context) => DetailScreen(city: '$Krakow'),
                  ),
                );
              },
              icon: const Icon(Icons.subject),
              label: const Text("Krakow")
          ),
        ],
      )
    );
  }
}
