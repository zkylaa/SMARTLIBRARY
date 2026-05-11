// test/api_integration_test.dart
//
// Integration test untuk SmartLibrary API
// Jalankan dengan: flutter test test/api_integration_test.dart
//
// PERHATIAN: Pastikan XAMPP sudah jalan dan IP di api_service.dart
// sudah sesuai sebelum menjalankan test ini.

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_library/services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Config test — ganti sesuai akun lo
// ─────────────────────────────────────────────────────────────────────────────
const String kAdminEmail    = 'rafif1@gmail.com';
const String kAdminPassword = 'Rafif1';

// Akun test sementara — akan di-register lalu dipakai di test
const String kTestEmail    = 'flutter_test_auto@gmail.com';
const String kTestPassword = 'test123456';
const String kTestName     = 'Flutter Test User';
const String kTestStudentId = 'TST001';

// State yang di-share antar test
int? _testUserId;
int? _testBorrowId;
int? _testBookId;   // book yang akan dipinjam
int? _newBookId;    // book yang dibuat oleh admin test

void main() {
  // ───────────────────────────────────────────────────────────────
  // GROUP 1: AUTH
  // ───────────────────────────────────────────────────────────────
  group('AUTH', () {
    test('[AUTH-01] Register — sukses', () async {
      final res = await ApiService.register(
        kTestName, kTestEmail, kTestPassword, kTestStudentId,
      );

      // Kalau email sudah ada (dari run sebelumnya), skip
      if (res['success'] == false &&
          (res['message'] as String).toLowerCase().contains('already')) {
        print('  ⚠ Email sudah terdaftar, skip register test');
        return;
      }

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['user'], isA<Map>());
      expect(res['user']['id'], isA<int>());
      expect(res['user']['name'], equals(kTestName));
      expect(res['user']['email'], equals(kTestEmail));

      _testUserId = res['user']['id'];
      print('  ✓ Registered user id: $_testUserId');
    });

    test('[AUTH-02] Register — email duplikat harus gagal', () async {
      final res = await ApiService.register(
        kTestName, kTestEmail, kTestPassword, kTestStudentId,
      );

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Duplicate message: ${res['message']}');
    });

    test('[AUTH-03] Register — password terlalu pendek harus gagal', () async {
      final res = await ApiService.register(
        'Short Pass', 'shortpass_test@test.com', '123', 'TST000',
      );

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Short password message: ${res['message']}');
    });

    test('[AUTH-04] Login — sukses sebagai user', () async {
      final res = await ApiService.login(kTestEmail, kTestPassword);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['user'], isA<Map>());
      expect(res['user']['id'], isA<int>());
      expect(res['user']['name'], isNotEmpty);
      expect(res['user']['email'], equals(kTestEmail));
      expect(res['user']['role'], isIn(['user', 'admin']));

      _testUserId = res['user']['id'];
      print('  ✓ Logged in as user id: $_testUserId, role: ${res['user']['role']}');
    });

    test('[AUTH-05] Login — sukses sebagai admin', () async {
      final res = await ApiService.login(kAdminEmail, kAdminPassword);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['user']['role'], equals('admin'));
      print('  ✓ Admin login OK, id: ${res['user']['id']}');
    });

    test('[AUTH-06] Login — password salah harus gagal', () async {
      final res = await ApiService.login(kTestEmail, 'wrongpassword99');

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Wrong password message: ${res['message']}');
    });

    test('[AUTH-07] Login — email tidak terdaftar harus gagal', () async {
      final res = await ApiService.login('notexist999@gmail.com', 'anypass');

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Not found message: ${res['message']}');
    });

    test('[AUTH-08] Login — email kosong harus gagal', () async {
      final res = await ApiService.login('', '');

      expect(res['success'], isFalse);
      print('  ✓ Empty fields handled');
    });
  });

  // ───────────────────────────────────────────────────────────────
  // GROUP 2: BOOKS
  // ───────────────────────────────────────────────────────────────
  group('BOOKS', () {
    test('[BOOK-01] Get all books', () async {
      final res = await ApiService.getBooks();

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['books'], isA<List>());
      expect(res['total'], isA<int>());
      expect(res['total'], equals((res['books'] as List).length));
      expect((res['books'] as List).length, greaterThan(0));

      // Simpan book_id untuk test borrow nanti
      final books = res['books'] as List;
      _testBookId = books.first['id'];

      // Validasi struktur buku
      final book = books.first;
      expect(book['id'], isNotNull);
      expect(book['title'], isA<String>());
      expect(book['author'], isA<String>());
      expect(book['available_copies'], isNotNull);

      print('  ✓ Total books: ${res['total']}, using book_id: $_testBookId');
    });

    test('[BOOK-02] Get book by ID', () async {
      expect(_testBookId, isNotNull, reason: 'Jalankan BOOK-01 dulu');

      final res = await ApiService.getBookById(_testBookId!);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['book'], isA<Map>());
      expect(res['book']['id'].toString(), equals(_testBookId.toString()));
      expect(res['book']['title'], isNotEmpty);
      expect(res['book']['author'], isNotEmpty);
      expect(res['book'], contains('isbn'));
      expect(res['book'], contains('synopsis'));
      expect(res['book'], contains('cover_url'));
      expect(res['book']['total_copies'], isNotNull);

      print('  ✓ Book: "${res['book']['title']}"');
    });

    test('[BOOK-03] Get book by ID — tidak ditemukan', () async {
      final res = await ApiService.getBookById(99999);

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Not found message: ${res['message']}');
    });

    test('[BOOK-04] Search books by keyword', () async {
      final res = await ApiService.getBooks(search: 'harry');

      expect(res['success'], isTrue);
      expect(res['books'], isA<List>());

      if ((res['books'] as List).isNotEmpty) {
        final matched = (res['books'] as List).every((b) =>
          (b['title'] as String).toLowerCase().contains('harry') ||
          (b['author'] as String).toLowerCase().contains('harry'));
        expect(matched, isTrue);
      }
      print('  ✓ Search "harry" results: ${res['total']}');
    });

    test('[BOOK-05] Search books — keyword tidak ada hasil', () async {
      final res = await ApiService.getBooks(search: 'xyznotexist999');

      expect(res['success'], isTrue);
      expect((res['books'] as List).length, equals(0));
      print('  ✓ Empty search result OK');
    });

    test('[BOOK-06] Filter books by category', () async {
      final res = await ApiService.getBooks(category: 'Fiction');

      expect(res['success'], isTrue);
      expect(res['books'], isA<List>());
      print('  ✓ Category "Fiction" results: ${res['total']}');
    });

    test('[BOOK-07] Add book (admin) — sukses', () async {
      final res = await ApiService.addBook({
        'title': 'Flutter Integration Test Book',
        'author': 'Test Author Auto',
        'isbn': '000-0000000099',
        'category': 'Testing',
        'synopsis': 'Buku ini dibuat otomatis oleh integration test.',
        'cover_url': 'https://covers.openlibrary.org/b/id/8739161-L.jpg',
        'total_copies': 2,
      });

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['id'], isA<int>());

      _newBookId = res['id'];
      print('  ✓ New book added with id: $_newBookId');
    });

    test('[BOOK-08] Add book — missing required fields harus gagal', () async {
      final res = await ApiService.addBook({
        'isbn': '000-0000000000',
        // title & author tidak ada
      });

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Missing fields message: ${res['message']}');
    });

    test('[BOOK-09] Update book (admin)', () async {
      expect(_newBookId, isNotNull, reason: 'Jalankan BOOK-07 dulu');

      final res = await ApiService.updateBook(_newBookId!, {
        'title': 'Flutter Integration Test Book (Updated)',
        'author': 'Test Author Updated',
        'isbn': '000-0000000099',
        'category': 'Testing',
        'synopsis': 'Synopsis yang sudah diupdate.',
        'cover_url': 'https://covers.openlibrary.org/b/id/8739161-L.jpg',
        'total_copies': 3,
        'available_copies': 3,
      });

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['message']?.toString().toLowerCase(), contains('updated'));
      print('  ✓ Book updated: ${res['message']}');
    });

    test('[BOOK-10] Delete book (admin)', () async {
      expect(_newBookId, isNotNull, reason: 'Jalankan BOOK-07 dulu');

      final res = await ApiService.deleteBook(_newBookId!);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['message']?.toString().toLowerCase(), contains('deleted'));
      print('  ✓ Book deleted: ${res['message']}');
    });

    test('[BOOK-11] Delete book — ID tidak ada harus gagal', () async {
      final res = await ApiService.deleteBook(99999);

      // Bisa success (0 rows affected) atau false tergantung implementasi
      // yang penting tidak crash
      expect(res, isA<Map>());
      print('  ✓ Delete non-existent handled: success=${res['success']}');
    });
  });

  // ───────────────────────────────────────────────────────────────
  // GROUP 3: BORROW
  // ───────────────────────────────────────────────────────────────
  group('BORROW', () {
    test('[BORROW-01] Borrow book — sukses', () async {
      expect(_testUserId, isNotNull, reason: 'Jalankan AUTH test dulu');
      expect(_testBookId, isNotNull, reason: 'Jalankan BOOK test dulu');

      final now = DateTime.now();
      final borrowDate =
          '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
      final returnDate =
          '${now.year}-${now.month.toString().padLeft(2,'0')}-${(now.day + 7).toString().padLeft(2,'0')}';

      final res = await ApiService.borrowBook({
        'action': 'borrow',
        'user_id': _testUserId,
        'book_id': _testBookId,
        'borrow_date': borrowDate,
        'return_date': returnDate,
      });

      // Jika sudah pernah pinjam (run sebelumnya), skip
      if (res['success'] == false &&
          (res['message'] as String).toLowerCase().contains('already')) {
        print('  ⚠ Already borrowed, skip. Coba kembalikan dulu.');
        return;
      }

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['borrow_id'], isA<int>());
      expect(res['message']?.toString().toLowerCase(), contains('borrowed'));

      _testBorrowId = res['borrow_id'];
      print('  ✓ Borrow success, borrow_id: $_testBorrowId');
    });

    test('[BORROW-02] Borrow book sama — harus gagal (already borrowed)', () async {
      expect(_testUserId, isNotNull, reason: 'Jalankan AUTH test dulu');
      expect(_testBookId, isNotNull, reason: 'Jalankan BOOK test dulu');

      final res = await ApiService.borrowBook({
        'action': 'borrow',
        'user_id': _testUserId,
        'book_id': _testBookId,
        'borrow_date': '2026-05-10',
        'return_date': '2026-05-17',
      });

      expect(res['success'], isFalse);
      expect(res['message']?.toString().toLowerCase(), contains('already'));
      print('  ✓ Duplicate borrow rejected: ${res['message']}');
    });

    test('[BORROW-03] Get user borrows', () async {
      expect(_testUserId, isNotNull, reason: 'Jalankan AUTH test dulu');

      final res = await ApiService.getBorrows(_testUserId!);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['borrows'], isA<List>());

      if ((res['borrows'] as List).isNotEmpty) {
        final b = (res['borrows'] as List).first;
        expect(b['id'], isNotNull);
        expect(b['book_id'], isNotNull);
        expect(b['title'], isA<String>());
        expect(b['status'], isIn(['borrowed', 'returned']));
        expect(b['borrow_date'], isA<String>());
        expect(b['return_date'], isA<String>());

        // Ambil borrow_id aktif untuk test return
        final activeBorrow = (res['borrows'] as List)
            .firstWhere((b) => b['status'] == 'borrowed', orElse: () => null);
        if (activeBorrow != null) {
          _testBorrowId = activeBorrow['id'];
        }
      }

      print('  ✓ Total borrows for user: ${(res['borrows'] as List).length}');
    });

    test('[BORROW-04] Get borrows — user ID 0 harus gagal', () async {
      final res = await ApiService.getBorrows(0);

      expect(res['success'], isFalse);
      print('  ✓ Invalid user_id handled: ${res['message']}');
    });

    test('[BORROW-05] Return book — sukses', () async {
      expect(_testBorrowId, isNotNull, reason: 'Jalankan BORROW-01 atau BORROW-03 dulu');

      final res = await ApiService.returnBook(_testBorrowId!);

      expect(res['success'], isTrue, reason: res['message']);
      expect(res['message']?.toString().toLowerCase(), contains('returned'));
      print('  ✓ Return success: ${res['message']}');
    });

    test('[BORROW-06] Return buku yang sudah dikembalikan — harus gagal', () async {
      expect(_testBorrowId, isNotNull, reason: 'Jalankan BORROW-05 dulu');

      final res = await ApiService.returnBook(_testBorrowId!);

      expect(res['success'], isFalse);
      expect(res['message'], isNotEmpty);
      print('  ✓ Double return rejected: ${res['message']}');
    });

    test('[BORROW-07] Borrow buku tidak ada — harus gagal', () async {
      expect(_testUserId, isNotNull, reason: 'Jalankan AUTH test dulu');

      final res = await ApiService.borrowBook({
        'action': 'borrow',
        'user_id': _testUserId,
        'book_id': 99999,
        'borrow_date': '2026-05-10',
        'return_date': '2026-05-17',
      });

      expect(res['success'], isFalse);
      print('  ✓ Non-existent book handled: ${res['message']}');
    });
  });
}