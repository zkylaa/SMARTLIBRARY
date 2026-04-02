import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _trendingBooks = [
    {
      'id': 1,
      'title': "The Alchemist's Shadow",
      'author': 'Luna Voss',
      'color': const Color(0xFF1A3A4F),
      'progress': 0.45,
      'rating': 4.5,
      'pages': 324,
      'image': 'https://covers.openlibrary.org/b/id/8739161-L.jpg',
      'synopsis':
          'A young shepherd journeys across the desert in search of a treasure, discovering that the real wealth lies within himself.',
    },
    {
      'id': 2,
      'title': 'Echoes of the Past',
      'author': 'Marcus Reed',
      'color': const Color(0xFF2D1B4E),
      'progress': 0.0,
      'rating': 4.2,
      'pages': 280,
      'image': 'https://covers.openlibrary.org/b/id/10527843-L.jpg',
      'synopsis':
          'A detective unravels a mystery that stretches across decades, uncovering dark secrets buried deep in a forgotten city.',
    },
    {
      'id': 3,
      'title': 'The Quiet Storm',
      'author': 'Aria Chen',
      'color': const Color(0xFF1B3A2D),
      'progress': 0.0,
      'rating': 4.7,
      'pages': 412,
      'image': 'https://covers.openlibrary.org/b/id/9255566-L.jpg',
      'synopsis':
          'In the silence before the storm, one woman must choose between loyalty and the truth that could change everything.',
    },
    {
      'id': 4,
      'title': 'The Midnight Library',
      'author': 'Matt Haig',
      'color': const Color(0xFF1A2A4A),
      'progress': 0.0,
      'rating': 4.8,
      'pages': 304,
      'image': 'https://covers.openlibrary.org/b/id/10527946-L.jpg',
      'synopsis':
          'Between life and death there is a library, and its shelves go on forever. Each book provides a chance to try another life.',
    },
    {
      'id': 5,
      'title': 'Dune',
      'author': 'Frank Herbert',
      'color': const Color(0xFF3A2A1A),
      'progress': 0.0,
      'rating': 4.9,
      'pages': 688,
      'image': 'https://covers.openlibrary.org/b/id/8763128-L.jpg',
      'synopsis':
          'A sweeping tale of politics, religion, and ecology set on the desert planet Arrakis, home to the most valuable substance in the universe.',
    },
  ];

  final List<Map<String, dynamic>> _collections = [
    {
      'title': 'Fiction',
      'count': '124 Books',
      'color': const Color(0xFF1A1A3E),
      'image': 'https://covers.openlibrary.org/b/id/8739161-L.jpg',
      'icon': Icons.auto_stories,
    },
    {
      'title': 'Science',
      'count': '89 Books',
      'color': const Color(0xFF0D2137),
      'image': 'https://covers.openlibrary.org/b/id/8775187-L.jpg',
      'icon': Icons.science_outlined,
    },
    {
      'title': 'History',
      'count': '67 Books',
      'color': const Color(0xFF2D1B00),
      'image': 'https://covers.openlibrary.org/b/id/9255566-L.jpg',
      'icon': Icons.history_edu_outlined,
    },
    {
      'title': 'Poetry',
      'count': '45 Books',
      'color': const Color(0xFF1B002D),
      'image': 'https://covers.openlibrary.org/b/id/10527843-L.jpg',
      'icon': Icons.format_quote_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: SafeArea(
        child: _currentIndex == 0
            ? _buildHomeBody()
            : _currentIndex == 1
                ? _buildBooksPage()
                : _currentIndex == 2
                    ? _buildBorrowPage()
                    : _buildProfilePage(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ══════════════════════════════════════════
  //  HOME BODY
  // ══════════════════════════════════════════

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          _buildRecentlyRead(),
          _buildTrendingNow(),
          _buildCollections(),
          _buildCuratedSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'The Scriptorium',
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.search, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyRead() {
    final book = _trendingBooks[0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Read',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _goToDetail(book),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: book['color'],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Book cover image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book['image'],
                      width: 70,
                      height: 95,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 95,
                        color: Colors.black26,
                        child: const Icon(Icons.book,
                            color: Colors.white54, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Progress',
                          style: GoogleFonts.raleway(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: book['progress'],
                            backgroundColor: Colors.white24,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(book['progress'] * 100).toInt()}% completed',
                          style: GoogleFonts.raleway(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _goToDetail(book),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: book['color'],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Continue Reading',
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTrendingNow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Now',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Text(
                    'See all →',
                    style: GoogleFonts.raleway(
                      color: const Color(0xFF2D6A8F),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _trendingBooks.length,
              itemBuilder: (context, index) {
                final book = _trendingBooks[index];
                return GestureDetector(
                  onTap: () => _goToDetail(book),
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: book['color'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Cover image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            book['image'],
                            width: 130,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: book['color'],
                              child: const Center(
                                child: Icon(Icons.book,
                                    color: Colors.white24, size: 48),
                              ),
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Title
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book['title'],
                                style: GoogleFonts.cormorantGaramond(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                book['author'],
                                style: GoogleFonts.raleway(
                                  color: Colors.white60,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFFFD700), size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  '${book['rating']}',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collections',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all →',
                style: GoogleFonts.raleway(
                  color: const Color(0xFF2D6A8F),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: _collections.length,
            itemBuilder: (context, index) {
              final col = _collections[index];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening ${col['title']} collection...',
                        style: GoogleFonts.raleway(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF2D6A8F),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: col['color'],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Image.network(
                          col['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: col['color']),
                        ),
                        // Dark overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                (col['color'] as Color).withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                col['icon'] as IconData,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                col['title'],
                                style: GoogleFonts.cormorantGaramond(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                col['count'],
                                style: GoogleFonts.raleway(
                                  color: Colors.white54,
                                  fontSize: 10,
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCuratedSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curated for the',
              style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Inquisitive Mind',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Our librarians have hand-picked a stunning collection of works exploring the intersection of art, philosophy, and technology.',
              style: GoogleFonts.raleway(
                color: Colors.white54,
                fontSize: 12,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _currentIndex = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Explore Collection',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  BOOKS PAGE (tab index 1)
  // ══════════════════════════════════════════

  Widget _buildBooksPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                'All Books',
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.search, color: Colors.white54),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: _trendingBooks.length,
            itemBuilder: (context, index) {
              final book = _trendingBooks[index];
              return GestureDetector(
                onTap: () => _goToDetail(book),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              book['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: book['color'],
                                child: const Icon(Icons.book,
                                    color: Colors.white24, size: 40),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Color(0xFFFFD700), size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${book['rating']}',
                                      style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 10,
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
                    const SizedBox(height: 8),
                    Text(
                      book['title'],
                      style: GoogleFonts.cormorantGaramond(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      book['author'],
                      style: GoogleFonts.raleway(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  BORROW PAGE (tab index 2)
  // ══════════════════════════════════════════

  Widget _buildBorrowPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Borrowings',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                final book = _trendingBooks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book['image'],
                          width: 55,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 55,
                            height: 75,
                            color: book['color'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: GoogleFonts.cormorantGaramond(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'by ${book['author']}',
                              style: GoogleFonts.raleway(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Color(0xFF2D6A8F), size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  'Due: 15 Apr 2026',
                                  style: GoogleFonts.raleway(
                                    color: const Color(0xFF2D6A8F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.raleway(
                            color: Colors.green,
                            fontSize: 11,
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

  // ══════════════════════════════════════════
  //  PROFILE PAGE (tab index 3)
  // ══════════════════════════════════════════

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF2D6A8F),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            'Scholar Member',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'scholar@scriptorium.com',
            style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatCard('12', 'Books\nBorrowed'),
              const SizedBox(width: 12),
              _buildStatCard('3', 'Currently\nReading'),
              const SizedBox(width: 12),
              _buildStatCard('28', 'Wishlist'),
            ],
          ),
          const SizedBox(height: 24),
          _buildProfileMenu(Icons.history, 'Borrow History'),
          _buildProfileMenu(Icons.bookmark_outline, 'My Wishlist'),
          _buildProfileMenu(Icons.settings_outlined, 'Settings'),
          _buildProfileMenu(Icons.logout, 'Logout', isRed: true),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String label,
      {bool isRed = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isRed ? Colors.red.shade400 : Colors.white54,
                size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.raleway(
                color: isRed ? Colors.red.shade400 : Colors.white70,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  BOTTOM NAV
  // ══════════════════════════════════════════

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.book_outlined, 'label': 'Books'},
      {'icon': Icons.bookmark_outline, 'label': 'Borrow'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isActive = _currentIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[index]['icon'] as IconData,
                    color: isActive
                        ? const Color(0xFF2D6A8F)
                        : Colors.white38,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label'] as String,
                    style: GoogleFonts.raleway(
                      color: isActive
                          ? const Color(0xFF2D6A8F)
                          : Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _goToDetail(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }
}