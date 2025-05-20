import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';

class AuthProvider with ChangeNotifier {
  int? _currentUserId;
  String? _currentUsername;

  int? get currentUserId => _currentUserId;
  String? get currentUsername => _currentUsername;

  Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      _currentUserId = result.first['id'] as int;
      _currentUsername = result.first['username'] as String;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert('users', {'username': username, 'password': password});
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _currentUserId = null;
    _currentUsername = null;
    notifyListeners();
  }
} 