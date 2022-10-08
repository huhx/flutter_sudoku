import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SudokuRecordApi {
  final tableName = 'sudoku_record';
  final dbName = 'sudoku_record.db';
  final tableScript = '''
    CREATE TABLE sudoku_record(
      id TEXT PRIMARY KEY,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      day INTEGER NOT NULL,
      difficulty INTEGER NOT NULL,
      status TEXT NOT NULL,
      duration INTEGER NOT NULL,
      createTime INTEGER NOT NULL
    )
  ''';

  Future<void> insert(SudokuRecord sudokuRecord) async {
    final Database db = await _getDB();
    await db.insert(tableName, sudokuRecord.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SudokuRecord>> querySudokuRecord(SudokuRequest request) async {
    final Database db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'year = ? and month = ? and day = ? and difficulty = ?',
      whereArgs: [request.year, request.month, request.day, request.difficulty.level],
      orderBy: 'createTime desc',
    );
    return maps.map((json) => SudokuRecord.fromJson(json)).toList();
  }

  Future<List<SudokuRecord>> querySudokuRecords(int pageNum) async {
    final Database db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      offset: (pageNum - 1) * 20,
      limit: 20,
      orderBy: 'createTime desc',
    );
    return maps.map((json) => SudokuRecord.fromJson(json)).toList();
  }

  Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) => db.execute(tableScript),
      version: 1,
    );
  }
}

final readLogApi = SudokuRecordApi();
