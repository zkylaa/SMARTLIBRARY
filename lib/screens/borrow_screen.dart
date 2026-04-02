import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorrowScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BorrowScreen({super.key, required this.book});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  DateTime _borrowDate = DateTime.now();
  DateTime _returnDate = DateTime.now().add(const Duration(days: 7));
  String _selectedDuration = '1 Week';
  bool _agreeToTerms = false;
  bool _isProcessing = false;

  final List<String> _durations = ['1 Week', '2 Weeks', '1 Month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildBookPreview(),
              _buildLoanAgreement(),
              _buildDateSection(),
              _buildDurationSelector(),
              _buildPickupMethod(),
              _buildTermsCheckbox(),
              _buildProcessButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
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
          ),
          const SizedBox(width: 16),
          Text(
            'Borrow a Book',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookPreview() {
    final book = widget.book;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            // Book cover
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: book['color'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.book, color: Colors.white38, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'READING FREELY',
                    style: GoogleFonts.raleway(
                      color: const Color(0xFF2D6A8F),
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['title'],
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'by ${book['author']}',
                    style: GoogleFonts.raleway(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 8),
                      const SizedBox(width: 6),
                      Text(
                        'Available',
                        style: GoogleFonts.raleway(
                          color: Colors.green,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${book['pages']} Pages',
                        style: GoogleFonts.raleway(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanAgreement() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Agreement',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please review the terms of your borrowing request.',
            style: GoogleFonts.raleway(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildDateCard(
              label: 'Borrow Date',
              date: _borrowDate,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _borrowDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFF2D6A8F),
                          surface: Color(0xFF1A1A2E),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _borrowDate = picked;
                    _updateReturnDate();
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDateCard(
              label: 'Return Date',
              date: _returnDate,
              onTap: null,
              isReadOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required DateTime date,
    required VoidCallback? onTap,
    bool isReadOnly = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isReadOnly ? Colors.white12 : const Color(0xFF2D6A8F),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.raleway(
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${date.day} ${_monthName(date.month)}',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${date.year}',
              style: GoogleFonts.raleway(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
            if (!isReadOnly) ...[
              const SizedBox(height: 4),
              Text(
                'Tap to change',
                style: GoogleFonts.raleway(
                  color: const Color(0xFF2D6A8F),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Duration',
            style: GoogleFonts.raleway(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _durations.map((duration) {
              final isSelected = _selectedDuration == duration;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDuration = duration;
                      _updateReturnDate();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                    child: Center(
                      child: Text(
                        duration,
                        style: GoogleFonts.raleway(
                          color: isSelected ? Colors.white : Colors.white38,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Method',
            style: GoogleFonts.raleway(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2D6A8F)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.library_books_outlined,
                  color: Color(0xFF2D6A8F),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In-Library Pickup',
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Collect from The Scriptorium desk',
                        style: GoogleFonts.raleway(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2D6A8F),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
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
                      text:
                          'I agree to the Scriptorium\'s borrowing terms and acknowledge that I am responsible for returning the book in good condition by the agreed date. ',
                    ),
                    TextSpan(
                      text: 'Read full terms →',
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
      ),
    );
  }

  Widget _buildProcessButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _agreeToTerms && !_isProcessing ? _processBorrow : null,
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
                  'PROCESS DIGITAL LOAN →',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 13,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _updateReturnDate() {
    int days = 7;
    if (_selectedDuration == '2 Weeks') days = 14;
    if (_selectedDuration == '1 Month') days = 30;
    setState(() {
      _returnDate = _borrowDate.add(Duration(days: days));
    });
  }

  void _processBorrow() async {
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
              Icons.check_circle_outline,
              color: Color(0xFF2D6A8F),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Loan Confirmed!',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your book will be ready for pickup at The Scriptorium desk.',
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
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Back to Home',
                style: GoogleFonts.raleway(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}