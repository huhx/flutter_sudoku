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

  void add(SudokuStack sudokuStack) {
    _sudokuStacks.add(sudokuStack);
  }

  SudokuStack undo() {
    return _sudokuStacks.removeLast();
  }

  void clear() {
    _sudokuStacks.clear();
  }
}
