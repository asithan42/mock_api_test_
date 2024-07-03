import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE items (
  id INTEGER PRIMARY KEY,
  name TEXT,
  description TEXT
)
    ''');
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('items');
    return result;
  }
}
