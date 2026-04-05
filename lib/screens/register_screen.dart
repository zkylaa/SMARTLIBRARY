// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String _selectedMembership = 'Scholar';
  final List<String> _memberships = ['Scholar', 'Scribe', 'Archivist'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final studentId = _studentIdController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack('Please fill all required fields', isError: true);
      return;
    }
    if (!_agreeToTerms) {
      _showSnack('Please agree to the terms', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService.register(name, email, password, studentId);
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      _showSnack('Registration successful! Please login.');
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _showSnack(result['message'] ?? 'Registration failed', isError: true);
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
      backgroundColor: const Color(0xFF0F0E17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildField('FULL NAME', _nameController, 'Enter your full name'),
              const SizedBox(height: 16),
              _buildField('EMAIL', _emailController, 'Enter your email',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildField('STUDENT ID', _studentIdController, 'e.g. STD2024001'),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildMembershipSelector(),
              const SizedBox(height: 24),
              _buildTermsCheckbox(),
              const SizedBox(height: 24),
              _buildRegisterButton(),
              const SizedBox(height: 24),
              _buildLoginLink(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Join the Order.',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('CREATE YOUR SCHOLAR ACCOUNT',
              style: GoogleFonts.raleway(
                  color: Colors.white38, fontSize: 10, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.raleway(
                color: Colors.white54, fontSize: 10,
                letterSpacing: 2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDeco(hint),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PASSWORD',
            style: GoogleFonts.raleway(
                color: Colors.white54, fontSize: 10,
                letterSpacing: 2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDeco('Minimum 6 characters').copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.white38, size: 18,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MEMBERSHIP TYPE',
            style: GoogleFonts.raleway(
                color: Colors.white54, fontSize: 10,
                letterSpacing: 2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: _memberships.map((m) {
            final isSelected = _selectedMembership == m;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMembership = m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2D6A8F)
                        : const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2D6A8F) : Colors.white12,
                    ),
                  ),
                  child: Text(m,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        color: isSelected ? Colors.white : Colors.white38,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
          checkColor: Colors.white,
          fillColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? const Color(0xFF2D6A8F)
                  : Colors.transparent),
          side: const BorderSide(color: Colors.white38),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                text: 'I agree to the ',
                style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: GoogleFonts.raleway(
                        color: const Color(0xFF2D6A8F),
                        decoration: TextDecoration.underline),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: GoogleFonts.raleway(
                        color: const Color(0xFF2D6A8F),
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _doRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D6A8F),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text('COMPLETE INITIATION',
                style: GoogleFonts.raleway(
                    fontSize: 13, letterSpacing: 2,
                    color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen())),
        child: RichText(
          text: TextSpan(
            text: 'Already a member? ',
            style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13),
            children: [
              TextSpan(
                text: 'Sign in here.',
                style: GoogleFonts.raleway(
                    color: const Color(0xFF2D6A8F),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1A1A2E),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D6A8F))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}