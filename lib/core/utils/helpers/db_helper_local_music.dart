import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperMusic {
  static final DBHelperMusic _instance = DBHelperMusic._internal();
  factory DBHelperMusic() => _instance;
  DBHelperMusic._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'backgrounds.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE backgrounds (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          imagePath TEXT,
          musicPath TEXT,
          recordingPath TEXT,
          type TEXT
        )
      ''');
      },
    );
  }

  // Insert Method
  Future<int> insertBackground(Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert('backgrounds', data);
    } catch (e) {
      throw Exception('Error inserting background: $e');
    }
  }

  // Update Method
  Future<int> updateBackground(Map<String, dynamic> data, int id) async {
    try {
      final db = await database;
      return await db.update(
        'backgrounds',
        data,
        where: 'id = ?', // Ensure it's filtering by ID
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error updating background: $e');
    }
  }


// Fetch Data Method
  Future<List<Map<String, dynamic>>> fetchBackgrounds() async {
    try {
      final db = await database;
      return await db.query('backgrounds');
    } catch (e) {
      throw Exception('Error fetching backgrounds: $e');
    }
  }

  // Delete Background by ID
  Future<void> deleteBackground(int id) async {
    final db = await database;
    await db.delete(
      'backgrounds',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
