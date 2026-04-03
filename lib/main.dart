// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/session_service.dart';

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
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2D6A8F),
          surface: Color(0xFF1A1A2E),
        ),
        textTheme: GoogleFonts.cormorantTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SplashGate(),
    );
  }
}

/// Cek sesi saat buka app: kalau sudah login → HomeScreen, kalau belum → LoginScreen
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 600)); // brief splash
    final loggedIn = await SessionService.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => loggedIn ? const HomeScreen() : const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A4F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.menu_book, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 20),
            Text('The Scriptorium',
                style: GoogleFonts.cormorantGaramond(
                    color: Colors.white, fontSize: 28,
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
                color: Color(0xFF2D6A8F), strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}