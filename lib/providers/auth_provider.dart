import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AuthProvider with ChangeNotifier {
  int? _userId;
  int? get userId => _userId;

  Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      _userId = result.first['id'] as int;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('users', {'username': username, 'password': password});
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _userId = null;
    notifyListeners();
  }
} 