import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'borrow_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isWishlisted = false;

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
            _buildSynopsis(),
            _buildDetails(book),
            _buildSimilarBooks(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCover(Map<String, dynamic> book) {
    return Stack(
      children: [
        // Background gradient cover
        // Ganti bagian Center( child: Container(...) ) di dalam hero cover:
        Center(
          child: Container(
            width: 140,
            height: 200,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: book['color'],
                  child: const Icon(
                    Icons.book,
                    color: Colors.white24,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Back button
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _isWishlisted = !_isWishlisted);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isWishlisted ? Icons.bookmark : Icons.bookmark_border,
                      color: _isWishlisted
                          ? const Color(0xFF2D6A8F)
                          : Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Genre tags
          Row(
            children: [
              _buildTag('FICTION'),
              const SizedBox(width: 8),
              _buildTag('MYSTERY'),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            book['title'],
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),

          // Author
          Text(
            'by ${book['author']}',
            style: GoogleFonts.raleway(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Star rating
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < (book['rating'] as double).floor()
                      ? Icons.star
                      : index < book['rating']
                      ? Icons.star_half
                      : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${book['rating']} (128 reviews)',
                style: GoogleFonts.raleway(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.raleway(
          color: Colors.white54,
          fontSize: 10,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildStats(Map<String, dynamic> book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          _buildStatItem('${book['pages']}', 'Pages'),
          _buildDivider(),
          _buildStatItem('${book['rating']}', 'Rating'),
          _buildDivider(),
          _buildStatItem('2024', 'Year'),
          _buildDivider(),
          _buildStatItem('English', 'Language'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.raleway(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.white12);
  }

  Widget _buildActionButtons(Map<String, dynamic> book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BorrowScreen(book: book),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A8F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Borrow Now →',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add List',
                style: GoogleFonts.raleway(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synopsis',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Somewhere, out loud, with a edge of the universe, there is a library that contains all the books ever written. Each spine tells the story of a different life, a different choice. The library of Midnight holds the stories of the lives we didn\'t get to live, and one extraordinary soul is about to discover what that means for her own.',
            style: GoogleFonts.raleway(
              color: Colors.white60,
              fontSize: 13,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> book) {
    final details = [
      {'label': 'Publisher', 'value': 'Midnight Press'},
      {'label': 'Published', 'value': 'August 13, 2020'},
      {'label': 'Genre', 'value': 'Fiction / Fantasy'},
      {'label': 'Language', 'value': 'English (US)'},
      {'label': 'ISBN-10', 'value': '0525559477'},
      {'label': 'ISBN-13', 'value': '978-0525559474'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Details',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...details.map(
            (d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    d['label']!,
                    style: GoogleFonts.raleway(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    d['value']!,
                    style: GoogleFonts.raleway(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarBooks() {
    final similar = [
      {'title': 'The Night Circus', 'color': const Color(0xFF1A1A2E)},
      {'title': 'Middlegame', 'color': const Color(0xFF1B2D1A)},
      {'title': 'Piranesi', 'color': const Color(0xFF2D1B1A)},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Similar Curations',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: similar.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: similar[index]['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.book,
                          color: Colors.white12,
                          size: 40,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          similar[index]['title'] as String,
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
