// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import '../models/book_model.dart';
import 'book_detail_screen.dart';
import 'login_screen.dart';
import 'manage_books_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _currentUser;

  // Books dari API
  List<BookModel> _allBooks = [];
  bool _booksLoading = true;

  // Borrows dari API
  List<Map<String, dynamic>> _borrows = [];
  bool _borrowsLoading = true;

  // Untuk halaman Books
  String _searchQuery = '';
  String _selectedCategory = '';
  final List<String> _categories = ['', 'Fiction', 'Science', 'History', 'Self-Help', 'Science Fiction', 'Poetry'];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadBooks();
  }

  Future<void> _loadUser() async {
    final user = await SessionService.getUser();
    setState(() => _currentUser = user);
    if (user != null) _loadBorrows(user['id']);
  }

  Future<void> _loadBooks({String search = '', String category = ''}) async {
    setState(() => _booksLoading = true);
    final result = await ApiService.getBooks(
        search: search.isEmpty ? null : search,
        category: category.isEmpty ? null : category);
    if (result['success'] == true) {
      final list = (result['books'] as List).map((b) => BookModel.fromJson(b)).toList();
      setState(() { _allBooks = list; _booksLoading = false; });
    } else {
      setState(() => _booksLoading = false);
    }
  }

  Future<void> _loadBorrows(int userId) async {
    setState(() => _borrowsLoading = true);
    final result = await ApiService.getBorrows(userId);
    if (result['success'] == true) {
      setState(() {
        _borrows = List<Map<String, dynamic>>.from(result['borrows'] ?? []);
        _borrowsLoading = false;
      });
    } else {
      setState(() => _borrowsLoading = false);
    }
  }

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<void> _returnBook(Map<String, dynamic> borrow) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Return Book', style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 20)),
        content: Text('Return "${borrow['title']}"?', style: GoogleFonts.raleway(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.raleway(color: Colors.white38))),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text('Return', style: GoogleFonts.raleway(color: const Color(0xFF2D6A8F)))),
        ],
      ),
    );
    if (confirm != true) return;
    final result = await ApiService.returnBook(int.parse(borrow['id'].toString()));
    if (result['success'] == true) {
      _showSnack('Book returned successfully!');
      _loadBorrows(_currentUser!['id']);
      _loadBooks(search: _searchQuery, category: _selectedCategory);
    } else {
      _showSnack(result['message'] ?? 'Failed to return', isError: true);
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      // ── Fixed AppBar — tidak ikut scroll ──
      appBar: _buildFixedAppBar(),
      body: _currentIndex == 0
          ? _buildHomeBody()
          : _currentIndex == 1
              ? _buildBooksPage()
              : _currentIndex == 2
                  ? _buildBorrowPage()
                  : _buildProfilePage(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ══════════════════════════════════════════
  //  FIXED APP BAR
  // ══════════════════════════════════════════

  PreferredSizeWidget _buildFixedAppBar() {
    // Judul berbeda tiap tab
    final titles = ['The Scriptorium', 'All Books', 'My Borrowings', 'Profile'];
    final isHome = _currentIndex == 0;

    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F0E17),
          border: Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kiri: judul/greeting
                isHome
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('THE SCRIPTORIUM',
                              style: GoogleFonts.raleway(
                                  color: Colors.white38, fontSize: 9, letterSpacing: 3)),
                          Text(
                            'Good Day, ${_currentUser?['name']?.split(' ').first ?? 'Scholar'}',
                            style: GoogleFonts.cormorantGaramond(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Text(
                        titles[_currentIndex],
                        style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),

                // Kanan: action icons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_outlined,
                          color: Color(0xFF2D6A8F), size: 22),
                      tooltip: 'Manage Books',
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ManageBooksScreen()));
                        _loadBooks(
                            search: _searchQuery, category: _selectedCategory);
                      },
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _currentIndex = 3),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: const Color(0xFF2D6A8F),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2)),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  HOME BODY
  // ══════════════════════════════════════════

  Widget _buildHomeBody() {
    return RefreshIndicator(
      onRefresh: () => _loadBooks(),
      color: const Color(0xFF2D6A8F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            _buildTrendingNow(),
            _buildCategorySection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1E3A4F), Color(0xFF2D6A8F)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_allBooks.length} Books Available',
                    style: GoogleFonts.cormorantGaramond(
                        color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${_borrows.where((b) => b['status'] == 'borrowed').length} currently borrowed by you',
                    style: GoogleFonts.raleway(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.local_library_outlined, color: Colors.white54, size: 48),
        ],
      ),
    );
  }

  Widget _buildTrendingNow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('All Books',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        if (_booksLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: Color(0xFF2D6A8F)),
          ))
        else if (_allBooks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(child: Text('No books yet. Add books from Manage Books.',
                style: GoogleFonts.raleway(color: Colors.white38))),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _allBooks.length,
              itemBuilder: (_, i) => _buildBookCard(_allBooks[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildBookCard(BookModel book) {
    return GestureDetector(
      onTap: () => _goToDetail(book),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: book.coverUrl.isNotEmpty
                  ? Image.network(book.coverUrl,
                      width: 130, height: 170, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _bookPlaceholder(130, 170))
                  : _bookPlaceholder(130, 170),
            ),
            const SizedBox(height: 8),
            Text(book.title,
                style: GoogleFonts.cormorantGaramond(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(book.author,
                style: GoogleFonts.raleway(color: Colors.white38, fontSize: 10),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('Browse by Category',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              {'label': 'All', 'icon': Icons.auto_stories},
              {'label': 'Fiction', 'icon': Icons.book},
              {'label': 'Science', 'icon': Icons.science_outlined},
              {'label': 'History', 'icon': Icons.history_edu_outlined},
              {'label': 'Self-Help', 'icon': Icons.self_improvement},
            ].map((c) {
              final cat = c['label'] as String;
              final isSelected = _selectedCategory == (cat == 'All' ? '' : cat);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat == 'All' ? '' : cat);
                  _loadBooks(search: _searchQuery, category: _selectedCategory);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2D6A8F) : const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected ? const Color(0xFF2D6A8F) : Colors.white12),
                  ),
                  child: Row(children: [
                    Icon(c['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.white38, size: 14),
                    const SizedBox(width: 6),
                    Text(cat,
                        style: GoogleFonts.raleway(
                            color: isSelected ? Colors.white : Colors.white54, fontSize: 12)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  BOOKS PAGE (tab 1)
  // ══════════════════════════════════════════

  Widget _buildBooksPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (v) {
                  _searchQuery = v;
                  _loadBooks(search: v, category: _selectedCategory);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _booksLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A8F)))
              : _allBooks.isEmpty
                  ? Center(
                      child: Text('No books found',
                          style: GoogleFonts.cormorantGaramond(color: Colors.white38, fontSize: 20)))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12, mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: _allBooks.length,
                      itemBuilder: (_, i) {
                        final book = _allBooks[i];
                        return GestureDetector(
                          onTap: () => _goToDetail(book),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(fit: StackFit.expand, children: [
                                    book.coverUrl.isNotEmpty
                                        ? Image.network(book.coverUrl, fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => _bookPlaceholder(double.infinity, double.infinity))
                                        : _bookPlaceholder(double.infinity, double.infinity),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          '${book.availableCopies} avail',
                                          style: GoogleFonts.raleway(color: Colors.white, fontSize: 9),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(book.title,
                                  style: GoogleFonts.cormorantGaramond(
                                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(book.author,
                                  style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
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
  //  BORROW PAGE (tab 2)
  // ══════════════════════════════════════════

  Widget _buildBorrowPage() {
    final activeBorrows = _borrows.where((b) => b['status'] == 'borrowed').toList();
    final history = _borrows.where((b) => b['status'] == 'returned').toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${activeBorrows.length} active · ${history.length} returned',
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 20),
          Expanded(
            child: _borrowsLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A8F)))
                : _borrows.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bookmark_border, color: Colors.white24, size: 64),
                            const SizedBox(height: 16),
                            Text('No borrowings yet',
                                style: GoogleFonts.cormorantGaramond(color: Colors.white38, fontSize: 20)),
                            const SizedBox(height: 8),
                            Text('Browse books and start borrowing!',
                                style: GoogleFonts.raleway(color: Colors.white24, fontSize: 13)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadBorrows(_currentUser!['id']),
                        color: const Color(0xFF2D6A8F),
                        child: ListView(
                          children: [
                            if (activeBorrows.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('ACTIVE',
                                    style: GoogleFonts.raleway(
                                        color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                              ),
                              ...activeBorrows.map((b) => _buildBorrowCard(b, active: true)),
                              const SizedBox(height: 16),
                            ],
                            if (history.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('HISTORY',
                                    style: GoogleFonts.raleway(
                                        color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                              ),
                              ...history.map((b) => _buildBorrowCard(b, active: false)),
                            ],
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowCard(Map<String, dynamic> borrow, {required bool active}) {
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
            child: borrow['cover_url'] != null && borrow['cover_url'].isNotEmpty
                ? Image.network(borrow['cover_url'], width: 55, height: 75, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _bookPlaceholder(55, 75))
                : _bookPlaceholder(55, 75),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(borrow['title'] ?? '',
                    style: GoogleFonts.cormorantGaramond(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                Text('by ${borrow['author'] ?? ''}',
                    style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF2D6A8F), size: 12),
                  const SizedBox(width: 4),
                  Text('Due: ${borrow['return_date'] ?? ''}',
                      style: GoogleFonts.raleway(
                          color: const Color(0xFF2D6A8F), fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          active
              ? ElevatedButton(
                  onPressed: () => _returnBook(borrow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A8F).withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Return', style: GoogleFonts.raleway(color: Colors.white, fontSize: 11)),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                  child: Text('Returned',
                      style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11)),
                ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  PROFILE PAGE (tab 3)
  // ══════════════════════════════════════════

  Widget _buildProfilePage() {
    final name = _currentUser?['name'] ?? 'Scholar';
    final email = _currentUser?['email'] ?? '';
    final studentId = _currentUser?['student_id'] ?? '-';
    final activeBorrows = _borrows.where((b) => b['status'] == 'borrowed').length;
    final totalBorrows = _borrows.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
                color: const Color(0xFF2D6A8F),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2)),
            child: const Icon(Icons.person, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(email, style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 4),
          Text('Student ID: $studentId',
              style: GoogleFonts.raleway(color: Colors.white24, fontSize: 12)),
          const SizedBox(height: 24),
          Row(children: [
            _statCard('$totalBorrows', 'Total\nBorrowed'),
            const SizedBox(width: 12),
            _statCard('$activeBorrows', 'Active\nBorrows'),
            const SizedBox(width: 12),
            _statCard('${_allBooks.length}', 'Books in\nLibrary'),
          ]),
          const SizedBox(height: 24),
          _profileMenu(Icons.admin_panel_settings_outlined, 'Manage Books (Admin)',
              onTap: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ManageBooksScreen()));
            _loadBooks(search: _searchQuery, category: _selectedCategory);
          }),
          _profileMenu(Icons.bookmark_outline, 'My Borrowings',
              onTap: () => setState(() => _currentIndex = 2)),
          _profileMenu(Icons.logout, 'Logout', isRed: true, onTap: _logout),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12)),
        child: Column(children: [
          Text(val,
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _profileMenu(IconData icon, String label,
      {bool isRed = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12)),
        child: Row(children: [
          Icon(icon, color: isRed ? Colors.red.shade400 : Colors.white54, size: 20),
          const SizedBox(width: 12),
          Text(label,
              style: GoogleFonts.raleway(
                  color: isRed ? Colors.red.shade400 : Colors.white70, fontSize: 14)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        ]),
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
          border: Border(top: BorderSide(color: Colors.white12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isActive = _currentIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _currentIndex = index);
              if (index == 0) _loadBooks(search: _searchQuery, category: _selectedCategory);
              if (index == 2 && _currentUser != null) _loadBorrows(_currentUser!['id']);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(items[index]['icon'] as IconData,
                    color: isActive ? const Color(0xFF2D6A8F) : Colors.white38, size: 24),
                const SizedBox(height: 4),
                Text(items[index]['label'] as String,
                    style: GoogleFonts.raleway(
                        color: isActive ? const Color(0xFF2D6A8F) : Colors.white38, fontSize: 10)),
              ]),
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  HELPERS
  // ══════════════════════════════════════════

  void _goToDetail(BookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(
          book: {
            'id': book.id,
            'title': book.title,
            'author': book.author,
            'image': book.coverUrl,
            'synopsis': book.synopsis,
            'category': book.category,
            'available': book.availableCopies,
            'total': book.totalCopies,
            'color': const Color(0xFF1A3A4F),
            'rating': 4.5,
            'pages': 0,
          },
          userId: _currentUser?['id'],
        ),
      ),
    ).then((_) {
      _loadBooks(search: _searchQuery, category: _selectedCategory);
      if (_currentUser != null) _loadBorrows(_currentUser!['id']);
    });
  }

  Widget _bookPlaceholder(double w, double h) {
    return Container(
      width: w, height: h,
      color: const Color(0xFF2D6A8F).withOpacity(0.3),
      child: const Icon(Icons.book, color: Colors.white24, size: 32),
    );
  }
}