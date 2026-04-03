// lib/screens/search_openlibrary_screen.dart
// Consume API luar: Open Library (https://openlibrary.org)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class SearchOpenLibraryScreen extends StatefulWidget {
  const SearchOpenLibraryScreen({super.key});

  @override
  State<SearchOpenLibraryScreen> createState() =>
      _SearchOpenLibraryScreenState();
}

class _SearchOpenLibraryScreenState extends State<SearchOpenLibraryScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _results = [];
    });

    final results = await ApiService.searchOpenLibrary(q);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Search Open Library',
            style: GoogleFonts.cormorantGaramond(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF2D6A8F).withOpacity(0.15),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2D6A8F), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search millions of books from Open Library API, then import to your library',
                    style: GoogleFonts.raleway(color: Colors.white54, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'e.g. Harry Potter, Dune, Atomic Habits...',
                      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF1A1A2E),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A8F),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text('Search',
                      style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF2D6A8F)),
                        SizedBox(height: 16),
                        Text('Fetching from Open Library...',
                            style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  )
                : !_hasSearched
                    ? _buildInitialState()
                    : _results.isEmpty
                        ? _buildNoResults()
                        : _buildResultList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_stories_outlined, color: Colors.white24, size: 72),
          const SizedBox(height: 16),
          Text('Search the World\'s Books',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white54, fontSize: 22)),
          const SizedBox(height: 8),
          Text('Powered by Open Library API',
              style: GoogleFonts.raleway(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: Colors.white24, size: 56),
          const SizedBox(height: 16),
          Text('No books found',
              style: GoogleFonts.cormorantGaramond(color: Colors.white54, fontSize: 20)),
          const SizedBox(height: 8),
          Text('Try a different search term',
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _results.length,
      itemBuilder: (_, i) => _buildResultCard(_results[i]),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book['cover_url'] != ''
                  ? Image.network(book['cover_url'],
                      width: 55, height: 80, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book['title'],
                      style: GoogleFonts.cormorantGaramond(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('by ${book['author']}',
                      style: GoogleFonts.raleway(color: Colors.white54, fontSize: 12)),
                  if (book['year'] != '') ...[
                    const SizedBox(height: 2),
                    Text('Published: ${book['year']}',
                        style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11)),
                  ],
                  if (book['isbn'] != '') ...[
                    const SizedBox(height: 2),
                    Text('ISBN: ${book['isbn']}',
                        style: GoogleFonts.raleway(color: Colors.white38, fontSize: 11)),
                  ],
                  if (book['category'] != '') ...[
                    const SizedBox(height: 6),
                    Text(book['category'],
                        style: GoogleFonts.raleway(color: const Color(0xFF2D6A8F), fontSize: 11),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),

            // Import button
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, book),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A8F),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Import',
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 55, height: 80,
      color: const Color(0xFF2D6A8F).withOpacity(0.3),
      child: const Icon(Icons.book, color: Colors.white24),
    );
  }
}