import 'package:equatable/equatable.dart';

class SudokuConfig extends Equatable {
  final int retryCount;
  final int tipCount;

  const SudokuConfig({
    required this.retryCount,
    required this.tipCount,
  });

  @override
  List<Object?> get props => [retryCount, tipCount];
}

const sudokuConfig = SudokuConfig(retryCount: 3, tipCount: 10);
