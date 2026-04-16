import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Settings Table
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS ${DatabaseConstants.settingsTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isPathAvailable INTEGER DEFAULT 0,
        recordings_path TEXT
      )''',
    );

    // Notification Details Table
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS ${DatabaseConstants.notificationDetailsTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        repeat_interval TEXT NOT NULL DEFAULT '${DatabaseConstants.repeatIntervalDaily}'
      )''',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        '''CREATE TABLE IF NOT EXISTS ${DatabaseConstants.notificationDetailsTable}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL
        )''',
      );
    }

    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE ${DatabaseConstants.notificationDetailsTable} "
        "ADD COLUMN ${DatabaseConstants.notificationRepeatInterval} TEXT NOT NULL "
        "DEFAULT '${DatabaseConstants.repeatIntervalDaily}'",
      );
    }
  }

  // Generic Insert
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Generic Update
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  // Generic Delete
  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Generic Query
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  // Get single record
  Future<Map<String, dynamic>?> queryOne(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    final result = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Raw Query
  Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    final db = await database;
    return await db.rawQuery(sql);
  }

  // Raw Update
  Future<int> rawUpdate(String sql) async {
    final db = await database;
    return await db.rawUpdate(sql);
  }

  // Close Database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Clear all tables
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(DatabaseConstants.settingsTable);
    await db.delete(DatabaseConstants.notificationDetailsTable);
  }
}
