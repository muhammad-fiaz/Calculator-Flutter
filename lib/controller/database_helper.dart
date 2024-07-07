import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:calculator/models/history_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = await getDatabasesPath();
    path = join(path, 'calculator.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT,
        result TEXT
      )
    ''');
  }

  Future<int> insertHistory(HistoryModel history) async {
    var client = await db;
    return client.insert('history', history.toMap());
  }

  Future<List<HistoryModel>> fetchAllHistory() async {
    var client = await db;
    var res = await client.query('history');
    if (res.isNotEmpty) {
      return res.map((history) => HistoryModel.fromMap(history)).toList();
    }
    return [];
  }
}
