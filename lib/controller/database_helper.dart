import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:calculator/models/history_model.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
    try {
      String path = await getDatabasesPath();
      path = join(path, 'calculator.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      rethrow; // Rethrow the error after recording it
    }
  }

  void _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expression TEXT,
          result TEXT
        )
      ''');
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      rethrow; // Rethrow the error after recording it
    }
  }

  Future<int> insertHistory(HistoryModel history) async {
    try {
      var client = await db;
      return await client.insert('history', history.toMap());
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return -1; // Return a failure indicator or handle as needed
    }
  }

  Future<List<HistoryModel>> fetchAllHistory() async {
    try {
      var client = await db;
      var res = await client.query('history');
      if (res.isNotEmpty) {
        return res.map((history) => HistoryModel.fromMap(history)).toList();
      }
      return [];
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return []; // Return empty list or handle as needed
    }
  }
}
