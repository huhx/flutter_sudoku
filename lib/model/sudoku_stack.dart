import 'dart:collection';

import 'package:equatable/equatable.dart';

class SudokuStack extends Equatable {
  final int row;
  final int column;
  final bool isNote;
  final int oldValue;
  final int newValue;

  const SudokuStack({
    required this.row,
    required this.column,
    required this.isNote,
    required this.oldValue,
    required this.newValue,
  });

  @override
  List<Object?> get props => [row, column, isNote, oldValue, newValue];
}

class ChangeStack {
  final Queue<SudokuStack> _sudokuStacks = Queue();

  bool get isNotEmpty => _sudokuStacks.isNotEmpty;

  bool get isEmpty => _sudokuStacks.isEmpty;

  SudokuStack? current() {
    return _sudokuStacks.isEmpty ? null : _sudokuStacks.last;
  }

  void add({required int row, required int column, required int newValue, required bool isNote}) {
    final SudokuStack? sudokuStack = current();
    int oldValue = 0;
    if (sudokuStack != null && sudokuStack.row == row && sudokuStack.column == column) {
      oldValue = sudokuStack.newValue;
    }
    final SudokuStack newSudokuStack = SudokuStack(
      row: row,
      column: column,
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
