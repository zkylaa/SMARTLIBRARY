// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _keepSignedIn = false;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.login(email, password);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // Simpan sesi
      await SessionService.saveUser(result['user']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showSnack(result['message'] ?? 'Login failed', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A4F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
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

              // Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text('IDENTITY',
                    style: GoogleFonts.raleway(
                        fontSize: 10, letterSpacing: 2,
                        color: const Color(0xFF1E3A4F), fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'Enter your scholar email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CIPHER',
                      style: GoogleFonts.raleway(
                          fontSize: 10, letterSpacing: 2,
                          color: const Color(0xFF1E3A4F), fontWeight: FontWeight.w600)),
                  Text('FORGOTTEN YOUR CREDENTIALS?',
                      style: GoogleFonts.raleway(
                          fontSize: 10, letterSpacing: 1,
                          color: const Color(0xFF2D6A8F), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••',
                obscure: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF1E3A4F).withOpacity(0.5),
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Switch(
                    value: _keepSignedIn,
                    onChanged: (val) => setState(() => _keepSignedIn = val),
                    activeThumbColor: const Color(0xFF1E3A4F),
                  ),
                  const SizedBox(width: 8),
                  Text('Keep me signed in',
                      style: GoogleFonts.raleway(fontSize: 13, color: const Color(0xFF1E3A4F))),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A4F),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ENTER THE SCRIPTORIUM',
                                style: GoogleFonts.raleway(
                                    fontSize: 13, letterSpacing: 2,
                                    color: Colors.white, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'New to the order? ',
                    style: GoogleFonts.raleway(
                        fontSize: 13, color: const Color(0xFF1E3A4F).withOpacity(0.6)),
                    children: [
                      TextSpan(
                        text: 'Join us here.',
                        style: GoogleFonts.raleway(
                          fontSize: 13, color: const Color(0xFF2D6A8F),
                          decoration: TextDecoration.underline, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF1E3A4F)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF1E3A4F).withOpacity(0.4), fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        suffixIcon: suffix,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFF1E3A4F).withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFF1E3A4F).withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1E3A4F))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}