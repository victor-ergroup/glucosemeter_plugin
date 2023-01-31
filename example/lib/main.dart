import 'package:flutter/material.dart';
import 'package:glucosemeter_plugin_example/main_page.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/' : (context) => const MainPage(),
      },
    )
  );
}
