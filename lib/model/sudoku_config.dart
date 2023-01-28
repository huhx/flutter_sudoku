import 'package:equatable/equatable.dart';

import 'sudoku_tip.dart';

class SudokuConfig extends Equatable {
  final int retryCount;
  final int tipCount;
  final TipLevel tipLevel;

  const SudokuConfig({
    required this.retryCount,
    required this.tipCount,
    required this.tipLevel,
  });

  @override
  List<Object?> get props => [retryCount, tipCount];
}

const SudokuConfig sudokuConfig = SudokuConfig(
  retryCount: 3,
  tipCount: 10,
  tipLevel: TipLevel.none,
);
