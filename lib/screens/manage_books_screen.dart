// lib/screens/manage_books_screen.dart
// Halaman CRUD Buku (Tambah, Edit, Hapus)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/book_model.dart';
import 'search_openlibrary_screen.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  List<BookModel> _books = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {    
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getBooks(search: _searchQuery);
    if (result['success'] == true) {
      final list = result['books'] as List<dynamic>;
      setState(() {
        _books = list.map((b) => BookModel.fromJson(b)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      _showSnack(result['message'] ?? 'Failed to load books', isError: true);
    }
  }

  Future<void> _deleteBook(BookModel book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Delete Book',
            style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 20)),
        content: Text('Delete "${book.title}"? This cannot be undone.',
            style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.raleway(color: Colors.white38))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete', style: GoogleFonts.raleway(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    final result = await ApiService.deleteBook(book.id);
    if (result['success'] == true) {
      _showSnack('Book deleted');
      _loadBooks();
    } else {
      _showSnack(result['message'] ?? 'Delete failed', isError: true);
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Manage Books',
            style: GoogleFonts.cormorantGaramond(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Tombol search dari Open Library
          IconButton(
            icon: const Icon(Icons.travel_explore, color: Color(0xFF2D6A8F)),
            tooltip: 'Search Open Library',
            onPressed: () async {
              final imported = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(builder: (_) => const SearchOpenLibraryScreen()),
              );
              if (imported != null) {
                await _showBookForm(prefill: imported);
              }
            },
          ),
          // Tombol tambah buku manual
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2D6A8F)),
            tooltip: 'Add Book Manually',
            onPressed: () => _showBookForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A8F)))
                : _books.isEmpty
                    ? _buildEmptyState()
                    : _buildBookList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
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
        onChanged: (val) {
          _searchQuery = val;
          _loadBooks();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_books_outlined, color: Colors.white24, size: 64),
          const SizedBox(height: 16),
          Text('No books found',
              style: GoogleFonts.cormorantGaramond(color: Colors.white54, fontSize: 20)),
          const SizedBox(height: 8),
          Text('Tap + to add a book',
              style: GoogleFonts.raleway(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return RefreshIndicator(
      onRefresh: _loadBooks,
      color: const Color(0xFF2D6A8F),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _books.length,
        itemBuilder: (_, i) => _buildBookCard(_books[i]),
      ),
    );
  }

  Widget _buildBookCard(BookModel book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: book.coverUrl.isNotEmpty
              ? Image.network(book.coverUrl,
                  width: 48, height: 68, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _coverPlaceholder())
              : _coverPlaceholder(),
        ),
        title: Text(book.title,
            style: GoogleFonts.cormorantGaramond(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author,
                style: GoogleFonts.raleway(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Row(children: [
              _chip(book.category.isEmpty ? 'Uncategorized' : book.category, const Color(0xFF1E3A4F)),
              const SizedBox(width: 6),
              _chip('${book.availableCopies}/${book.totalCopies} avail',
                  book.availableCopies > 0 ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3)),
            ]),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: const Color(0xFF1A1A2E),
          icon: const Icon(Icons.more_vert, color: Colors.white54),
          onSelected: (val) {
            if (val == 'edit') _showBookForm(book: book);
            if (val == 'delete') _deleteBook(book);
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(children: [
                const Icon(Icons.edit_outlined, color: Color(0xFF2D6A8F), size: 18),
                const SizedBox(width: 8),
                Text('Edit', style: GoogleFonts.raleway(color: Colors.white)),
              ]),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(children: [
                Icon(Icons.delete_outline, color: Colors.red[400], size: 18),
                const SizedBox(width: 8),
                Text('Delete', style: GoogleFonts.raleway(color: Colors.red[400])),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      width: 48, height: 68,
      color: const Color(0xFF2D6A8F).withOpacity(0.3),
      child: const Icon(Icons.book, color: Colors.white24, size: 24),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: GoogleFonts.raleway(color: Colors.white70, fontSize: 10)),
    );
  }

  // ─── FORM DIALOG (Create & Edit) ─────────────────────────────
  Future<void> _showBookForm({BookModel? book, Map<String, dynamic>? prefill}) async {
    final isEdit = book != null;
    final titleCtrl = TextEditingController(text: isEdit ? book.title : (prefill?['title'] ?? ''));
    final authorCtrl = TextEditingController(text: isEdit ? book.author : (prefill?['author'] ?? ''));
    final isbnCtrl = TextEditingController(text: isEdit ? book.isbn : (prefill?['isbn'] ?? ''));
    final categoryCtrl = TextEditingController(text: isEdit ? book.category : (prefill?['category'] ?? ''));
    final synopsisCtrl = TextEditingController(text: isEdit ? book.synopsis : '');
    final coverCtrl = TextEditingController(text: isEdit ? book.coverUrl : (prefill?['cover_url'] ?? ''));
    final totalCtrl = TextEditingController(text: isEdit ? book.totalCopies.toString() : '1');
    final availCtrl = TextEditingController(text: isEdit ? book.availableCopies.toString() : '1');

    bool isSaving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModal) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4,
                        decoration: BoxDecoration(color: Colors.white24,
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  Text(isEdit ? 'Edit Book' : 'Add New Book',
                      style: GoogleFonts.cormorantGaramond(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _formField('Title *', titleCtrl),
                  const SizedBox(height: 12),
                  _formField('Author *', authorCtrl),
                  const SizedBox(height: 12),
                  _formField('ISBN', isbnCtrl),
                  const SizedBox(height: 12),
                  _formField('Category', categoryCtrl),
                  const SizedBox(height: 12),
                  _formField('Cover URL', coverCtrl),
                  const SizedBox(height: 12),
                  _formField('Synopsis', synopsisCtrl, maxLines: 3),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _formField('Total Copies', totalCtrl,
                        keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _formField('Available', availCtrl,
                        keyboardType: TextInputType.number)),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A8F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: isSaving ? null : () async {
                        if (titleCtrl.text.trim().isEmpty || authorCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Title and Author are required')));
                          return;
                        }
                        setModal(() => isSaving = true);
                        final data = {
                          'title': titleCtrl.text.trim(),
                          'author': authorCtrl.text.trim(),
                          'isbn': isbnCtrl.text.trim(),
                          'category': categoryCtrl.text.trim(),
                          'synopsis': synopsisCtrl.text.trim(),
                          'cover_url': coverCtrl.text.trim(),
                          'total_copies': int.tryParse(totalCtrl.text) ?? 1,
                          'available_copies': int.tryParse(availCtrl.text) ?? 1,
                        };
                        final result = isEdit
                            ? await ApiService.updateBook(book.id, data)
                            : await ApiService.addBook(data);
                        setModal(() => isSaving = false);
                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);
                        if (result['success'] == true) {
                          _showSnack(isEdit ? 'Book updated!' : 'Book added!');
                          _loadBooks();
                        } else {
                          _showSnack(result['message'] ?? 'Failed', isError: true);
                        }
                      },
                      child: isSaving
                          ? const SizedBox(height: 20, width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isEdit ? 'UPDATE BOOK' : 'ADD BOOK',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _formField(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.raleway(color: Colors.white54, fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F0E17),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white12)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2D6A8F))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}