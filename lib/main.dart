import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Scriptorium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF2D6A8F),
          surface: const Color(0xFF1A1A2E),
        ),
        textTheme: GoogleFonts.cormorantTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}