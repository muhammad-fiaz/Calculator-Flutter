import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalculationEntry {
  final int? id;
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationEntry({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory CalculationEntry.fromMap(Map<String, dynamic> map) {
    try {
      return CalculationEntry(
        id: map['id'] as int?,
        expression: map['expression'] as String? ?? '',
        result: map['result'] as String? ?? '',
        timestamp: map['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
            : DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing calculation entry: $e');
      }
      // Return a safe default entry if parsing fails
      return CalculationEntry(
        id: null,
        expression: 'Error loading',
        result: 'N/A',
        timestamp: DateTime.now(),
      );
    }
  }

  String get displayText => '${expression.trim()} = ${result.trim()}';
}

class HistoryProvider with ChangeNotifier {
  List<CalculationEntry> _history = [];
  Database? _database;

  List<CalculationEntry> get history => _history;
  int get historyCount => _history.length;

  Future<void> initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'calculator_history.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE calculations(id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result TEXT, timestamp INTEGER)',
          );
        },
      );

      await loadHistory();
    } on DatabaseException catch (e) {
      if (kDebugMode) {
        print('Database error initializing: $e');
      }
      // Initialize with empty history if database fails
      _history = [];
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error initializing database: $e');
      }
      // Initialize with empty history if database fails
      _history = [];
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error initializing database: $e');
      }
      // Initialize with empty history if database fails
      _history = [];
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    if (_database == null) {
      _history = [];
      notifyListeners();
      return;
    }

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'calculations',
        orderBy: 'timestamp DESC',
        limit: 100, // Limit to last 100 calculations
      );

      _history = maps.map((map) => CalculationEntry.fromMap(map)).toList();
      notifyListeners();
    } on DatabaseException catch (e) {
      if (kDebugMode) {
        print('Database error loading history: $e');
      }
      // Initialize with empty history if loading fails
      _history = [];
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error loading history: $e');
      }
      // Initialize with empty history if loading fails
      _history = [];
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error loading history: $e');
      }
      // Initialize with empty history if loading fails
      _history = [];
      notifyListeners();
    }
  }

  Future<void> addCalculation(String expression, String result) async {
    if (_database == null) {
      // Add to memory even if database is not available
      final calculation = CalculationEntry(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      );
      _history.insert(0, calculation);
      if (_history.length > 100) {
        _history = _history.sublist(0, 100);
      }
      notifyListeners();
      return;
    }

    try {
      final calculation = CalculationEntry(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      );

      final id = await _database!.insert(
        'calculations',
        calculation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Add to local list
      _history.insert(
        0,
        CalculationEntry(
          id: id,
          expression: expression,
          result: result,
          timestamp: calculation.timestamp,
        ),
      );

      // Keep only last 100 entries in memory
      if (_history.length > 100) {
        _history = _history.sublist(0, 100);
      }

      notifyListeners();
    } on DatabaseException catch (e) {
      if (kDebugMode) {
        print('Database error adding calculation: $e');
      }
      // Still add to memory as fallback
      final calculation = CalculationEntry(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      );
      _history.insert(0, calculation);
      if (_history.length > 100) {
        _history = _history.sublist(0, 100);
      }
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error adding calculation: $e');
      }
      // Still add to memory as fallback
      final calculation = CalculationEntry(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      );
      _history.insert(0, calculation);
      if (_history.length > 100) {
        _history = _history.sublist(0, 100);
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error adding calculation: $e');
      }
      // Still add to memory as fallback
      final calculation = CalculationEntry(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      );
      _history.insert(0, calculation);
      if (_history.length > 100) {
        _history = _history.sublist(0, 100);
      }
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    if (_database == null) return;

    try {
      await _database!.delete('calculations');
      _history.clear();
      notifyListeners();
    } on DatabaseException catch (e) {
      if (kDebugMode) {
        print('Database error clearing history: $e');
      }
      // Clear local history even if database operation fails
      _history.clear();
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error clearing history: $e');
      }
      // Clear local history even if database operation fails
      _history.clear();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error clearing history: $e');
      }
      // Clear local history even if database operation fails
      _history.clear();
      notifyListeners();
    }
  }

  List<CalculationEntry> searchHistory(String query) {
    if (query.isEmpty) return _history;

    return _history.where((entry) {
      return entry.expression.toLowerCase().contains(query.toLowerCase()) ||
          entry.result.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Map<String, int> getStatistics() {
    Map<String, int> stats = {
      'totalCalculations': _history.length,
      'todayCalculations': 0,
      'thisWeekCalculations': 0,
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    for (var entry in _history) {
      if (entry.timestamp.isAfter(today)) {
        stats['todayCalculations'] = stats['todayCalculations']! + 1;
      }
      if (entry.timestamp.isAfter(weekAgo)) {
        stats['thisWeekCalculations'] = stats['thisWeekCalculations']! + 1;
      }
    }

    return stats;
  }

  Future<void> deleteCalculation(int id) async {
    if (_database == null) return;

    try {
      await _database!.delete('calculations', where: 'id = ?', whereArgs: [id]);

      _history.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } on DatabaseException catch (e) {
      if (kDebugMode) {
        print('Database error deleting calculation: $e');
      }
      // Remove from local list even if database operation fails
      _history.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error deleting calculation: $e');
      }
      // Remove from local list even if database operation fails
      _history.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error deleting calculation: $e');
      }
      // Remove from local list even if database operation fails
      _history.removeWhere((entry) => entry.id == id);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
