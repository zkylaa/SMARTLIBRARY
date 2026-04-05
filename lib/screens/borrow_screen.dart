// lib/screens/borrow_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class BorrowScreen extends StatefulWidget {
  final Map<String, dynamic> book;
  final int userId;

  const BorrowScreen({super.key, required this.book, required this.userId});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final DateTime _borrowDate = DateTime.now();
  DateTime _returnDate = DateTime.now().add(const Duration(days: 7));
  bool _isSubmitting = false;

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFF2D6A8F)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _returnDate = picked);
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    final result = await ApiService.borrowBook({
      'action': 'borrow',
      'user_id': widget.userId,
      'book_id': widget.book['id'],
      'borrow_date': _borrowDate.toIso8601String().split('T').first,
      'return_date': _returnDate.toIso8601String().split('T').first,
    });

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (result['success'] == true) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message'] ?? 'Failed to borrow'),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Color(0xFF2D6A8F), size: 64),
              const SizedBox(height: 16),
              Text('Success!',
                  style: GoogleFonts.cormorantGaramond(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('"${widget.book['title']}" has been borrowed.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                'Return by: ${_returnDate.day}/${_returnDate.month}/${_returnDate.year}',
                style: GoogleFonts.raleway(color: const Color(0xFF2D6A8F), fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context, true); // return to detail (true = success)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A8F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text('Done', style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Borrow Book',
            style: GoogleFonts.cormorantGaramond(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (book['image'] != null && book['image'].toString().isNotEmpty)
                        ? Image.network(book['image'],
                            width: 70, height: 100, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder())
                        : _placeholder(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book['title'] ?? '',
                            style: GoogleFonts.cormorantGaramond(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('by ${book['author'] ?? ''}',
                            style: GoogleFonts.raleway(color: Colors.white54, fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text('${book['available'] ?? 0} copies available',
                              style: GoogleFonts.raleway(color: Colors.green, fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('BORROW DETAILS',
                style: GoogleFonts.raleway(
                    color: Colors.white38, fontSize: 10, letterSpacing: 2)),
            const SizedBox(height: 16),

            // Borrow date (read-only)
            _dateRow('Borrow Date', _borrowDate, null),
            const SizedBox(height: 12),

            // Return date (pickable)
            _dateRow('Return Date', _returnDate, _pickReturnDate),
            const SizedBox(height: 8),

            Text(
              'Duration: ${_returnDate.difference(_borrowDate).inDays} days',
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 40),

            // Terms info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2D6A8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D6A8F).withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2D6A8F), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'By borrowing, you agree to return the book on time. '
                      'Late returns may result in account suspension.',
                      style: GoogleFonts.raleway(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A8F),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('CONFIRM BORROW',
                        style: GoogleFonts.raleway(
                            color: Colors.white, fontWeight: FontWeight.bold,
                            fontSize: 14, letterSpacing: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateRow(String label, DateTime date, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: onTap != null ? const Color(0xFF2D6A8F).withOpacity(0.4) : Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11, letterSpacing: 1)),
              const SizedBox(height: 4),
              Text('${date.day} / ${date.month} / ${date.year}',
                  style: GoogleFonts.cormorantGaramond(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            Icon(
              onTap != null ? Icons.edit_calendar_outlined : Icons.calendar_today_outlined,
              color: onTap != null ? const Color(0xFF2D6A8F) : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70, height: 100,
      color: const Color(0xFF2D6A8F).withOpacity(0.3),
      child: const Icon(Icons.book, color: Colors.white24, size: 32),
    );
  }
}