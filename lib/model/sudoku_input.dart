import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';

class SudokuInput extends Equatable {
  final Point point;
  final int value;
  final bool isCorrect;
  final bool useTip;
  final List<int> noteValues;

  const SudokuInput({
    required this.point,
    required this.value,
    required this.isCorrect,
    required this.useTip,
    required this.noteValues,
  });

  factory SudokuInput.inputClear(Point point) {
    return SudokuInput(point: point, value: 0, isCorrect: false, useTip: false, noteValues: const []);
  }

  factory SudokuInput.inputNote(Point point, List<int> noteValue) {
    return SudokuInput(point: point, value: 0, isCorrect: false, useTip: false, noteValues: noteValue);
  }

  factory SudokuInput.inputTip(Point point, int value) {
    return SudokuInput(point: point, value: value, isCorrect: true, useTip: true, noteValues: const []);
  }

  factory SudokuInput.inputValue(Point point, bool isCorrect, int value) {
    return SudokuInput(point: point, value: value, isCorrect: isCorrect, useTip: false, noteValues: const []);
  }

  @override
  List<Object?> get props => [point, value, isCorrect, useTip];
}
