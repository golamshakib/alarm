import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'alarms.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE alarms (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hour INTEGER,
      minute INTEGER,
      isAm INTEGER,
      label TEXT,
      backgroundImage TEXT,
      musicPath TEXT,
      repeatDays TEXT,
      isVibrationEnabled INTEGER,
      isToggled INTEGER
    )
  ''');
  }

  Future<int> insertAlarm(Map<String, dynamic> alarmData) async {
    final db = await database;
    return await db.insert('alarms', alarmData);
  }

  Future<List<Map<String, dynamic>>> getAlarms() async {
    final db = await database;
    return await db.query('alarms');
  }

  Future<int> updateAlarm(int id, Map<String, dynamic> alarmData) async {
    final db = await database;
    return await db.update('alarms', alarmData, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAlarm(int id) async {
    final db = await database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }
}
