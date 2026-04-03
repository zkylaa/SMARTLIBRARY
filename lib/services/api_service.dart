// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ─────────────────────────────────────────────────────────────
  // GANTI IP ini dengan IP komputer kamu saat pakai emulator!
  // Jika pakai emulator Android: 10.0.2.2
  // Jika pakai device fisik: IP WiFi laptop kamu (contoh: 192.168.1.5)
  // ─────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://172.20.10.6/scriptorium_api';

  // ══════════════════════════════════════════
  //  AUTH - Login & Register (PHP + MySQL)
  // ══════════════════════════════════════════

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String studentId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'student_id': studentId,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // ══════════════════════════════════════════
  //  BOOKS CRUD (PHP + MySQL)
  // ══════════════════════════════════════════

  /// Ambil semua buku (opsional: search & category filter)
  static Future<Map<String, dynamic>> getBooks({
    String? search,
    String? category,
  }) async {
    try {
      String url = '$baseUrl/books.php';
      final params = <String, String>{};
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (category != null && category.isNotEmpty) params['category'] = category;
      if (params.isNotEmpty) {
        url += '?' + params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      }
      final response = await http.get(Uri.parse(url));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Ambil detail 1 buku by ID
  static Future<Map<String, dynamic>> getBookById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books.php?id=$id'));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Tambah buku baru (CREATE)
  static Future<Map<String, dynamic>> addBook(
      Map<String, dynamic> bookData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Update buku (UPDATE)
  static Future<Map<String, dynamic>> updateBook(
      int id, Map<String, dynamic> bookData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/books.php?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Hapus buku (DELETE)
  static Future<Map<String, dynamic>> deleteBook(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/books.php?id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // ══════════════════════════════════════════
  //  BORROW
  // ══════════════════════════════════════════

  static Future<Map<String, dynamic>> borrowBook(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/borrow.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> returnBook(int borrowId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/borrow.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'return', 'borrow_id': borrowId}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getBorrows(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/borrow.php?user_id=$userId'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // ══════════════════════════════════════════
  //  CONSUME API LUAR - Open Library API
  //  Dokumentasi: https://openlibrary.org/developers/api
  // ══════════════════════════════════════════

  /// Cari buku dari Open Library berdasarkan keyword
  static Future<List<Map<String, dynamic>>> searchOpenLibrary(
      String query) async {
    try {
      final url = Uri.parse(
        'https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&limit=10&fields=key,title,author_name,first_publish_year,cover_i,isbn,subject',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final docs = data['docs'] as List<dynamic>;
        return docs.map((doc) {
          final coverId = doc['cover_i'];
          return {
            'title': doc['title'] ?? 'Unknown Title',
            'author': (doc['author_name'] as List?)?.first ?? 'Unknown Author',
            'isbn': (doc['isbn'] as List?)?.first ?? '',
            'year': doc['first_publish_year']?.toString() ?? '',
            'cover_url': coverId != null
                ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
                : '',
            'category': (doc['subject'] as List?)?.take(2).join(', ') ?? '',
            'source': 'openlibrary',
            'key': doc['key'] ?? '',
          };
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Ambil detail buku dari Open Library by work key (contoh: /works/OL45804W)
  static Future<Map<String, dynamic>?> getOpenLibraryDetail(
      String workKey) async {
    try {
      final response = await http.get(
        Uri.parse('https://openlibrary.org$workKey.json'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String synopsis = '';
        if (data['description'] != null) {
          if (data['description'] is String) {
            synopsis = data['description'];
          } else if (data['description'] is Map) {
            synopsis = data['description']['value'] ?? '';
          }
        }
        return {
          'title': data['title'] ?? '',
          'synopsis': synopsis,
          'covers': data['covers'] ?? [],
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}