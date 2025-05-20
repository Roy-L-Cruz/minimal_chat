import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    return await openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        is_admin INTEGER DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL,
        receiver_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    // Insert default admin user
    await db.insert('users', {
      'username': 'bot',
      'password': 'bot123',
      'is_admin': 1,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add is_admin column to users table
      await db.execute('ALTER TABLE users ADD COLUMN is_admin INTEGER DEFAULT 0');
      
      // Update bot user to be admin
      await db.update(
        'users',
        {'is_admin': 1},
        where: 'username = ?',
        whereArgs: ['bot'],
      );
    }
  }

  // Get all users except current user
  Future<List<Map<String, dynamic>>> getAllUsers(int currentUserId) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'id != ?',
      whereArgs: [currentUserId],
    );
  }

  // Get all chat partners for a user
  Future<List<Map<String, dynamic>>> getChatPartners(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT DISTINCT u.id, u.username, 
        (SELECT content FROM messages 
         WHERE (sender_id = ? AND receiver_id = u.id) 
            OR (sender_id = u.id AND receiver_id = ?)
         ORDER BY timestamp DESC LIMIT 1) as last_message,
        (SELECT timestamp FROM messages 
         WHERE (sender_id = ? AND receiver_id = u.id) 
            OR (sender_id = u.id AND receiver_id = ?)
         ORDER BY timestamp DESC LIMIT 1) as last_timestamp
      FROM users u
      INNER JOIN messages m ON (m.sender_id = u.id OR m.receiver_id = u.id)
      WHERE (m.sender_id = ? OR m.receiver_id = ?)
      AND u.id != ?
      ORDER BY last_timestamp DESC
    ''', [userId, userId, userId, userId, userId, userId, userId]);
    return result;
  }

  // Get messages between two users
  Future<List<Map<String, dynamic>>> getMessages(int userId1, int userId2) async {
    final db = await database;
    return await db.query(
      'messages',
      where: '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      whereArgs: [userId1, userId2, userId2, userId1],
      orderBy: 'timestamp ASC',
    );
  }

  // Delete all messages between two users
  Future<void> deleteChat(int userId1, int userId2) async {
    final db = await database;
    await db.delete(
      'messages',
      where: '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      whereArgs: [userId1, userId2, userId2, userId1],
    );
  }

  // Check if user is admin
  Future<bool> isUserAdmin(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['is_admin'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty && result.first['is_admin'] == 1;
  }

  // Get all users (admin only)
  Future<List<Map<String, dynamic>>> getAllUsersAdmin() async {
    final db = await database;
    return await db.query('users');
  }

  // Update user (admin only)
  Future<int> updateUserAdmin(int userId, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Delete user (admin only)
  Future<int> deleteUserAdmin(int userId) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Get all messages (admin only)
  Future<List<Map<String, dynamic>>> getAllMessagesAdmin() async {
    final db = await database;
    return await db.query('messages');
  }

  // Delete message (admin only)
  Future<int> deleteMessageAdmin(int messageId) async {
    final db = await database;
    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }
} 