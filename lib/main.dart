import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_animation/main_page/ui_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemStatusBarContrastEnforced: false,
          ),
          foregroundColor: Colors.white,
        ),
        primarySwatch: Colors.lime,
        fontFamily: GoogleFonts.josefinSans().fontFamily,
      ),
      home: const DiscoverPageProvider(),
    );
  }
}
