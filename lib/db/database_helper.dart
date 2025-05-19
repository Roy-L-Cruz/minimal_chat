import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chatapp.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER,
        receiver_id INTEGER,
        content TEXT,
        timestamp TEXT,
        FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    // Insert default user
    await db.insert('users', {
      'username': 'bot',
      'password': 'bot123',
    });
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
} 