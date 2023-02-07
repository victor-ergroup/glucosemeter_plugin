import 'package:flutter/material.dart';
import 'package:glucosemeter_plugin_example/main_page.dart';
import 'flutter_blue/flutter_blue_plus_example.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/' : (context) => const MainPage(),
        '/flutter-blue-plus-example': (context) => const FlutterBluePlusExample(),
      },
    )
  );
}
