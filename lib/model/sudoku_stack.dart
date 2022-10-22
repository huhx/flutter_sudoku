import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

class ChangeStack {
  final Queue<SudokuStack> _sudokuStacks = Queue();

  bool get isNotEmpty => _sudokuStacks.isNotEmpty;

  bool get isEmpty => _sudokuStacks.isEmpty;

  SudokuStack? current() {
    return _sudokuStacks.isEmpty ? null : _sudokuStacks.last;
  }

  void add({required Point point, required int newValue, required bool isNote}) {
    final SudokuStack? sudokuStack = current();
    int oldValue = 0;
    if (sudokuStack != null && sudokuStack.point == point) {
      oldValue = sudokuStack.newValue;
    }
    final SudokuStack newSudokuStack = SudokuStack(
      point: point,
      isNote: isNote,
      oldValue: oldValue,
      newValue: newValue,
    );
    _sudokuStacks.add(newSudokuStack);
  }

  SudokuStack undo() {
    return _sudokuStacks.removeLast();
  }

  void clear() {
    _sudokuStacks.clear();
  }
}

class SudokuStack extends Equatable {
  final Point point;
  final bool isNote;
  final int oldValue;
  final int newValue;

  const SudokuStack({
    required this.point,
    required this.isNote,
    required this.oldValue,
    required this.newValue,
  });

  @override
  List<Object?> get props => [point, isNote, oldValue, newValue];
}
