import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelperAlarm {
  static const String _tableName = 'alarms';
  static const String _dbName = 'alarm_database.db';

  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hour INTEGER,
            minute INTEGER,
            isAm INTEGER,
            label TEXT,
            backgroundImage TEXT,
            musicPath TEXT,
            recordingPath TEXT,
            repeatDays TEXT,
            isVibrationEnabled INTEGER,
            volume REAL,
            isToggled INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> insertAlarm(Map<String, dynamic> alarm) async {
    final db = await _getDatabase();
    await db.insert(
      _tableName,
      alarm,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchAlarms() async {
    final db = await _getDatabase();
    return await db.query(_tableName);
  }

  static Future<void> deleteAlarm(int id) async {
    final db = await _getDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateAlarm(Map<String, dynamic> alarm, int id) async {
    final db = await _getDatabase();
    await db.update(
      _tableName,
      alarm,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllAlarms() async {
    final db = await _getDatabase();
    await db.delete(_tableName);
  }
}
