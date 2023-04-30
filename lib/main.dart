import 'package:flutter/material.dart';
import 'package:test_animation/main_page/ui_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        primarySwatch: Colors.lime,
      ),
      home: const DiscoverPageProvider(),
    );
  }
}
