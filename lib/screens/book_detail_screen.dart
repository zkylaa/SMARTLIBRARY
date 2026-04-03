// lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'borrow_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;
  final int? userId;

  const BookDetailScreen({super.key, required this.book, this.userId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isWishlisted = false;
  bool _isBorrowing = false;

  Future<void> _borrowBook() async {
    if (widget.userId == null) {
      _showSnack('Please login first', isError: true);
      return;
    }

    final avail = widget.book['available'] ?? 0;
    if (avail <= 0) {
      _showSnack('No copies available right now', isError: true);
      return;
    }

    setState(() => _isBorrowing = true);

    // Tampilkan borrow form
    final borrowDate = DateTime.now();
    final returnDate = borrowDate.add(const Duration(days: 7));

    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BorrowScreen(
          book: widget.book,
          userId: widget.userId!,
        ),
      ),
    );

    setState(() => _isBorrowing = false);

    if (confirmed == true) {
      // Refresh state
      if (mounted) Navigator.pop(context, true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red[700] : Colors.green[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCover(book),
            _buildBookInfo(book),
            _buildStats(book),
            _buildActionButtons(book),
            _buildSynopsis(book),
            _buildDetails(book),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCover(Map<String, dynamic> book) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (book['color'] as Color? ?? const Color(0xFF1A3A4F)).withOpacity(0.8),
                const Color(0xFF0F0E17),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: 140, height: 200,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (book['image'] != null && book['image'].toString().isNotEmpty)
                  ? Image.network(book['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(book))
                  : _placeholder(book),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black38, borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      _isWishlisted ? Icons.bookmark : Icons.bookmark_border,
                      color: _isWishlisted ? const Color(0xFF2D6A8F) : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookInfo(Map<String, dynamic> book) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book['title'] ?? '',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('by ${book['author'] ?? ''}',
              style: GoogleFonts.raleway(color: Colors.white54, fontSize: 14)),
          if (book['category'] != null && book['category'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFF2D6A8F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D6A8F).withOpacity(0.4))),
              child: Text(book['category'],
                  style: GoogleFonts.raleway(color: const Color(0xFF2D6A8F), fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats(Map<String, dynamic> book) {
    final avail = book['available'] ?? 0;
    final total = book['total'] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _statItem(Icons.star, '${book['rating'] ?? '4.5'}', const Color(0xFFFFD700)),
          const SizedBox(width: 24),
          _statItem(Icons.copy_outlined, '$avail/$total copies', Colors.white54),
          const SizedBox(width: 24),
          _statItem(
            avail > 0 ? Icons.check_circle_outline : Icons.cancel_outlined,
            avail > 0 ? 'Available' : 'Unavailable',
            avail > 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, Color color) {
    return Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.raleway(color: Colors.white70, fontSize: 13)),
    ]);
  }

  Widget _buildActionButtons(Map<String, dynamic> book) {
    final avail = book['available'] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: (avail > 0 && !_isBorrowing) ? _borrowBook : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A8F),
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isBorrowing
                  ? const SizedBox(height: 18, width: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      avail > 0 ? 'BORROW THIS BOOK' : 'NOT AVAILABLE',
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis(Map<String, dynamic> book) {
    final synopsis = book['synopsis']?.toString() ?? '';
    if (synopsis.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SYNOPSIS',
              style: GoogleFonts.raleway(
                  color: Colors.white38, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(synopsis,
              style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DETAILS',
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 10),
          _detailRow('Author', book['author'] ?? '-'),
          _detailRow('Category', book['category'] ?? '-'),
          _detailRow('Total Copies', '${book['total'] ?? '-'}'),
          _detailRow('Available', '${book['available'] ?? '-'}'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13)),
          Text(value, style: GoogleFonts.raleway(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _placeholder(Map<String, dynamic> book) {
    return Container(
      color: book['color'] as Color? ?? const Color(0xFF1A3A4F),
      child: const Icon(Icons.book, color: Colors.white24, size: 64),
    );
  }
}