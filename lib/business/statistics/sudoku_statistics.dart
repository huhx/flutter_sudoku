import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';

class SudokuStatistics extends Equatable {
  final int totalCount;
  final int successCount;
  final int faileCount;
  final int bestTime;
  final int avgTime;
  final int straightWins;
  final int straightLose;

  const SudokuStatistics({
    required this.totalCount,
    required this.successCount,
    required this.faileCount,
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
      faileCount,
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
      faileCount: failed.length,
      bestTime: success.isEmpty ? 0 : success.map((record) => record.duration).reduce((a, b) => a > b ? b : a),
      avgTime: success.isEmpty ? 0 : success.map((e) => e.duration).reduce((a, b) => a + b) ~/ success.length,
      straightWins: getStraightWins(success),
      straightLose: getStraightLose(failed),
    );
  }

  static int getStraightWins(List<SudokuRecord> success) {
    return 12;
  }

  static int getStraightLose(List<SudokuRecord> failed) {
    return 4;
  }
}
