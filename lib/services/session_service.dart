// lib/services/session_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUser = 'logged_in_user';

  /// Simpan data user setelah login berhasil
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user));
  }

  /// Ambil data user yang sedang login
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyUser);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  /// Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {  
    final user = await getUser();
    return user != null;
  }

  /// Logout - hapus sesi
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}