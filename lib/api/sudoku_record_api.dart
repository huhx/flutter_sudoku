import 'dart:async';

import 'package:flutter_sudoku/business/statistics/sudoku_statistics.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SudokuRecordApi {
  static const String tableName = 'sudoku_record';
  static const String dbName = 'sudoku_record.db';
  static const String tableScript = '''
    CREATE TABLE sudoku_record(
      id INTEGER PRIMARY KEY,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      day INTEGER NOT NULL,
      difficulty INTEGER NOT NULL,
      gameStatus TEXT NOT NULL,
      logStatus TEXT NOT NULL,
      sudokuInputLog TEXT NOT NULL,
      duration INTEGER NOT NULL,
      errorCount INTEGER NOT NULL,
      tipCount INTEGER NOT NULL,
      startTime INTEGER NOT NULL,
      endTime INTEGER NOT NULL,
      createTime INTEGER NOT NULL
    )
  ''';

  Future<void> insert(SudokuRecord sudokuRecord) async {
    final Database db = await _getDB();
    await db.insert(tableName, sudokuRecord.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteAll() async {
    final Database db = await _getDB();
    await db.rawUpdate('UPDATE sudoku_record SET logStatus = ?', [LogStatus.delete.name]);
  }

  Future<void> clear() async {
    final Database db = await _getDB();
    await db.delete(tableName);
  }

  Future<List<SudokuRecord>> querySudokuRecord(SudokuRequest request) async {
    final Database db = await _getDB();
    final DateTime dateTime = request.dateTime;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'year = ? and month = ? and day = ? and difficulty = ?',
      whereArgs: [dateTime.year, dateTime.month, dateTime.day, request.difficulty.level],
      orderBy: 'createTime desc',
    );
    return maps.map((json) => SudokuRecord.fromJson(json)).toList();
  }

  Future<void> delete(int id) async {
    final Database db = await _getDB();
    await db.rawUpdate('UPDATE sudoku_record SET logStatus = ? where id = ?', [LogStatus.delete.name, id]);
  }

  Future<SudokuStatistics> queryStatistics(Difficulty difficulty) async {
    final Database db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'difficulty = ? and logStatus = ?',
      whereArgs: [difficulty.level, LogStatus.normal.name],
      orderBy: 'createTime desc',
    );
    final List<SudokuRecord> records = maps.map((json) => SudokuRecord.fromJson(json)).toList();
    return SudokuStatistics.from(records);
  }

  Future<List<SudokuRecord>> querySudokuRecords(int pageNum) async {
    final Database db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'logStatus = ?',
      whereArgs: [LogStatus.normal.name],
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
