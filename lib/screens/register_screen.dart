import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isProcessing = false;
  String _selectedMembership = 'Scholar';

  final List<String> _memberships = ['Scholar', 'Scribe', 'Archivist'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
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
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildMembershipSelector(),
              const SizedBox(height: 24),
              _buildNotificationToggle(),
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
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join the Order.',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the guild of literary minds. The Scriptorium awaits your application and our librarians will review your membership.',
            style: GoogleFonts.raleway(
              color: Colors.white38,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return _buildInputField(
      label: 'Your Name',
      hint: 'e.g. Aria Blackwood',
      controller: _nameController,
      icon: Icons.person_outline,
    );
  }

  Widget _buildEmailField() {
    return _buildInputField(
      label: 'Scholar Email',
      hint: 'scholar@scriptorium.com',
      controller: _emailController,
      icon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return _buildInputField(
      label: 'Student Number / ID',
      hint: 'e.g. STU-2024-0001',
      controller: _phoneController,
      icon: Icons.badge_outlined,
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.raleway(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.raleway(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.raleway(
              color: Colors.white24,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: Colors.white38, size: 18),
            filled: true,
            fillColor: const Color(0xFF1A1A2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2D6A8F)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CIPHER',
          style: GoogleFonts.raleway(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: GoogleFonts.raleway(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Create your secret cipher',
            hintStyle: GoogleFonts.raleway(
              color: Colors.white24,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Colors.white38,
              size: 18,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white38,
                size: 18,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            filled: true,
            fillColor: const Color(0xFF1A1A2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2D6A8F)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
        Text(
          'MEMBERSHIP TIER',
          style: GoogleFonts.raleway(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _memberships.map((tier) {
            final isSelected = _selectedMembership == tier;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMembership = tier),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2D6A8F)
                        : const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2D6A8F)
                          : Colors.white12,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        tier == 'Scholar'
                            ? Icons.school_outlined
                            : tier == 'Scribe'
                                ? Icons.edit_outlined
                                : Icons.archive_outlined,
                        color: isSelected ? Colors.white : Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tier,
                        style: GoogleFonts.raleway(
                          color: isSelected ? Colors.white : Colors.white38,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _receiveNotifications = true;

  Widget _buildNotificationToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF2D6A8F),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receive Notifications',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Get alerts for due dates and new arrivals',
                  style: GoogleFonts.raleway(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _receiveNotifications,
            onChanged: (val) {
              setState(() => _receiveNotifications = val);
            },
            activeColor: const Color(0xFF2D6A8F),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (val) {
            setState(() => _agreeToTerms = val ?? false);
          },
          activeColor: const Color(0xFF2D6A8F),
          side: const BorderSide(color: Colors.white38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.raleway(
                  color: Colors.white54,
                  fontSize: 12,
                  height: 1.6,
                ),
                children: [
                  const TextSpan(
                    text: 'I agree to the Scriptorium\'s ',
                  ),
                  TextSpan(
                    text: 'Terms of Membership',
                    style: GoogleFonts.raleway(
                      color: const Color(0xFF2D6A8F),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and our '),
                  TextSpan(
                    text: 'Privacy Scroll.',
                    style: GoogleFonts.raleway(
                      color: const Color(0xFF2D6A8F),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
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
        onPressed: _agreeToTerms && !_isProcessing ? _processRegister : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _agreeToTerms
              ? const Color(0xFF2D6A8F)
              : Colors.white12,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'REGISTER AS MEMBER →',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 13,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.raleway(
              color: Colors.white38,
              fontSize: 13,
            ),
            children: [
              const TextSpan(text: 'Already a member? '),
              TextSpan(
                text: 'Enter here.',
                style: GoogleFonts.raleway(
                  color: const Color(0xFF2D6A8F),
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processRegister() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isProcessing = false);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_outlined,
              color: Color(0xFF2D6A8F),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to the Order!',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your membership application has been received. Our librarians will review it shortly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white54,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Go to Login',
                style: GoogleFonts.raleway(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}