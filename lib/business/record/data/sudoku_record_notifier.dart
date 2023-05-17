import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/base_sudoku.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_input.dart';
import 'package:flutter_sudoku/model/sudoku_input_log.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/service/audio_service.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuRecordNotifier extends ChangeNotifier with BaseSudoku {
  final SudokuInputLog sudokuInputLog;

  late int currentIndex;
  late bool _disposed;
  late bool _showAnswer;

  SudokuRecordNotifier({required this.sudokuInputLog});

  void init() {
    question = toArray(sudokuInputLog.question);
    content = toArray(sudokuInputLog.question);
    answer = toArray(sudokuInputLog.answer);

    selected = Point.first();
    notesMap = {};

    highlightPoints = highlight();
    relatedPoints = related();
    textColorMap = {for (final point in empty()) point: inputColor};

    _disposed = false;
    _showAnswer = false;
    currentIndex = 0;
  }

  Future<GameStatus> resetPlay() async {
    currentIndex = 0;
    content = toArray(sudokuInputLog.question);

    while (!_disposed && currentIndex < sudokuInputLog.sudokuInputs.length) {
      await Future.delayed(const Duration(seconds: 1), () {
        final SudokuInput sudokuInput = sudokuInputLog.sudokuInputs[currentIndex];
        _onPlay(sudokuInput);
        if (!_disposed) {
          notifyListeners();
        }
        currentIndex++;
      });
    }
    return _disposed ? GameStatus.running : sudokuInputLog.gameStatus;
  }

  void toogleAnswer() {
    highlightPoints = [];
    relatedPoints = [];

    textColorMap = {for (final point in empty()) point: inputColor};
    notesMap.clear();
    selected = Point.from(-1, -1);
    if (_showAnswer) {
      content = toArray(sudokuInputLog.question);
    } else {
      content = toArray(sudokuInputLog.answer);
    }
    _showAnswer = !_showAnswer;

    notifyListeners();
  }

  void _onPlay(SudokuInput sudokuInput) {
    /**
     * There are four kinds of operation:
     * 1. note model
     * 2. input value
     * 3. clear
     * 4. use tip
     * 
     * But for point 2, 3, 4 they are actually the same:
     * 2. random value, maybe correct or wrong
     * 3. zero value
     * 4. correct value
     */
    GetIt.I<AudioService>().playInput();
    selected = sudokuInput.point;
    relatedPoints = related();

    // node model
    if (sudokuInput.noteValues.isNotEmpty) {
      notesMap[selected] = sudokuInput.noteValues;
      content[selected.x][selected.y] = sudokuInput.value;

      highlightPoints = [];
    } else {
      // input model
      content[selected.x][selected.y] = sudokuInput.value;
      notesMap[selected] = sudokuInput.noteValues;
      highlightPoints = highlight();
      textColorMap[selected] = sudokuInput.isCorrect ? inputColor : errorColor;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

final sudokuRecordProvider = ChangeNotifierProvider.autoDispose.family<SudokuRecordNotifier, SudokuInputLog>(
  (ref, sudokuInputLog) => SudokuRecordNotifier(sudokuInputLog: sudokuInputLog)..init(),
);
