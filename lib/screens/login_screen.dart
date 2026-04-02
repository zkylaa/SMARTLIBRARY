import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _keepSignedIn = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A4F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'The Scriptorium',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A4F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SANCTUARY OF THE WRITTEN WORD',
                style: GoogleFonts.raleway(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: const Color(0xFF1E3A4F).withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 48),

              // Identity label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'IDENTITY',
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: const Color(0xFF1E3A4F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Email field
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Color(0xFF1E3A4F)),
                decoration: InputDecoration(
                  hintText: 'Enter your scholar email',
                  hintStyle: TextStyle(
                    color: const Color(0xFF1E3A4F).withOpacity(0.4),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: const Color(0xFF1E3A4F).withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: const Color(0xFF1E3A4F).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF1E3A4F)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Cipher + Forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CIPHER',
                    style: GoogleFonts.raleway(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: const Color(0xFF1E3A4F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'FORGOTTEN YOUR CREDENTIALS?',
                    style: GoogleFonts.raleway(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: const Color(0xFF2D6A8F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Color(0xFF1E3A4F)),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                    color: const Color(0xFF1E3A4F).withOpacity(0.4),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF1E3A4F).withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: const Color(0xFF1E3A4F).withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: const Color(0xFF1E3A4F).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF1E3A4F)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Keep me signed in
              Row(
                children: [
                  Switch(
                    value: _keepSignedIn,
                    onChanged: (val) {
                      setState(() {
                        _keepSignedIn = val;
                      });
                    },
                    activeColor: const Color(0xFF1E3A4F),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Keep me signed in',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: const Color(0xFF1E3A4F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A4F),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ENTER THE SCRIPTORIUM',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          letterSpacing: 2,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Or authenticate via
              Text(
                'OR AUTHENTICATE VIA',
                style: GoogleFonts.raleway(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: const Color(0xFF1E3A4F).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),

              // Google & Apple buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata, size: 20),
                      label: Text(
                        'GOOGLE',
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E3A4F),
                        side: BorderSide(
                          color: const Color(0xFF1E3A4F).withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple, size: 20),
                      label: Text(
                        'APPLE',
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E3A4F),
                        side: BorderSide(
                          color: const Color(0xFF1E3A4F).withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Register link
              RichText(
                text: TextSpan(
                  text: 'New to the order? ',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    color: const Color(0xFF1E3A4F).withOpacity(0.6),
                  ),
                  children: [
                    TextSpan(
                      text: 'Join us here.',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: const Color(0xFF2D6A8F),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
