import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../features/add_alarm/controller/add_alarm_controller.dart';

class DBHelperAlarm {
  static final DBHelperAlarm _instance = DBHelperAlarm._internal();
  factory DBHelperAlarm() => _instance;

  static Database? _database;

  DBHelperAlarm._internal();

  /// Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Create the database and the alarms table
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'alarms.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE alarms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hour INTEGER,
            minute INTEGER,
            isAm INTEGER,
            label TEXT,
            backgroundTitle TEXT,
            backgroundImage TEXT,
            musicPath TEXT,
            recordingPath TEXT,
            repeatDays TEXT,
            isVibrationEnabled INTEGER,
            snoozeDuration INTEGER,
            volume REAL,
            isToggled INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  /// Insert a new alarm into the database
  Future<int> insertAlarm(Alarm alarm) async {
    final db = await database;
    return db.insert('alarms', alarm.toMap());
  }

  /// Fetch all alarms from the database
  Future<List<Alarm>> fetchAlarms() async {
    final db = await database;
    final maps = await db.query('alarms');

    return List.generate(maps.length, (i) {
      return Alarm.fromMap(maps[i]);
    });
  }

  /// Update an existing alarm
  Future<int> updateAlarm(Alarm alarm) async {
    final db = await database;
    return db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  /// Delete an alarm by ID
  Future<int> deleteAlarm(int id) async {
    final db = await database;
    return db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  /// Clear all alarms from the database (if needed)
  Future<int> clearAlarms() async {
    final db = await database;
    return db.delete('alarms');
  }

  /// Close the database connection
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
