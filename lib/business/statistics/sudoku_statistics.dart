import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';

class SudokuStatistics extends Equatable {
  final int totalCount;
  final int successCount;
  final int failedCount;
  final int bestTime;
  final int avgTime;
  final int straightWins;
  final int straightLose;

  const SudokuStatistics({
    required this.totalCount,
    required this.successCount,
    required this.failedCount,
    required this.bestTime,
    required this.avgTime,
    required this.straightWins,
    required this.straightLose,
  });

  @override
  List<Object?> get props {
    return [
      totalCount,
      successCount,
      failedCount,
      bestTime,
      avgTime,
      straightWins,
      straightLose,
    ];
  }

  static SudokuStatistics from(List<SudokuRecord> records) {
    final List<SudokuRecord> success = records.where((record) => record.gameStatus == GameStatus.success).toList();
    final List<SudokuRecord> failed = records.where((record) => record.gameStatus == GameStatus.failed).toList();

    return SudokuStatistics(
      totalCount: records.length,
      successCount: success.length,
      failedCount: failed.length,
      bestTime: success.isEmpty ? 0 : success.map((record) => record.duration).reduce(min),
      avgTime: success.isEmpty ? 0 : success.map((e) => e.duration).reduce((a, b) => a + b) ~/ success.length,
      straightWins: getStraightWins(records),
      straightLose: getStraightLose(records),
    );
  }

  static int getStraightWins(List<SudokuRecord> records) {
    int maximum = 0, current = 0;
    final int length = records.length;
    for (int i = 0; i < length; i++) {
      if (records[i].gameStatus == GameStatus.success) {
        current += 1;
      } else {
        maximum = max(maximum, current);
        current = 0;
      }
    }
    return max(maximum, current);
  }

  static int getStraightLose(List<SudokuRecord> records) {
    int maximum = 0, current = 0;
    final int length = records.length;
    for (int i = 0; i < length; i++) {
      if (records[i].gameStatus == GameStatus.failed) {
        current += 1;
      } else {
        maximum = max(maximum, current);
        current = 0;
      }
    }
    return max(maximum, current);
  }
}
