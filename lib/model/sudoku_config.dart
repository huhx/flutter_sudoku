import 'package:equatable/equatable.dart';

import 'sudoku_tip.dart';

class SudokuConfig extends Equatable {
  final int retryCount;
  final int tipCount;
  final TipLevel tipLevel;
  final bool isMemeber;

  const SudokuConfig({
    required this.retryCount,
    required this.tipCount,
    required this.tipLevel,
    required this.isMemeber,
  });

  @override
  List<Object?> get props => [retryCount, tipCount, tipLevel, isMemeber];
}

const SudokuConfig sudokuConfig = SudokuConfig(
  retryCount: 3,
  tipCount: 3,
  tipLevel: TipLevel.none,
  isMemeber: true,
);
