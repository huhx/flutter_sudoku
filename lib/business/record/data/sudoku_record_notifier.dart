import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/string_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_input.dart';
import 'package:flutter_sudoku/model/sudoku_input_log.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuRecordNotifier extends ChangeNotifier {
  final SudokuInputLog sudokuInputLog;

  late List<List<int>> question;
  late List<List<int>> content;
  late List<List<int>> answer;

  late bool enableNotes;
  late Map<Point, List<int>?> notesMap;

  late Map<Point, Color> textColorMap;
  late List<Point> highlightPoints;
  late List<Point> relatedPoints;

  late Point selected;
  late GameStatus gameStatus;

  SudokuRecordNotifier(this.sudokuInputLog);

  void init() {
    question = toSudokuArray(sudokuInputLog.question);
    content = toSudokuArray(sudokuInputLog.question);
    answer = toSudokuArray(sudokuInputLog.answer);

    selected = Point.first();
    enableNotes = false;
    notesMap = {};
    gameStatus = GameStatus.running;

    highlightPoints = _highlight();
    relatedPoints = _related();
    textColorMap = {for (final point in _empty()) point: inputColor};
  }

  GameStatus onPlay(SudokuInput sudokuInput) {
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
    selected = sudokuInput.point;
    relatedPoints = _related();

    // node model
    if (sudokuInput.noteValues.isNotEmpty) {
      notesMap[selected] = sudokuInput.noteValues;
      content[selected.x][selected.y] = sudokuInput.value;

      highlightPoints = [];

      notifyListeners();
      return gameStatus;
    }

    // input model
    content[selected.x][selected.y] = sudokuInput.value;
    notesMap[selected] = sudokuInput.noteValues;
    highlightPoints = _highlight();
    textColorMap[selected] = sudokuInput.isCorrect ? inputColor : errorColor;

    notifyListeners();

    return gameStatus;
  }

  Color? getColor(Point point) {
    if (point == selected) {
      return selectedColor;
    }

    if (highlightPoints.contains(point)) {
      return highlightColor;
    }

    if (relatedPoints.contains(point)) {
      return relatedColor;
    }
    return null;
  }

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  List<int>? getNoteValue(Point point) {
    return notesMap[point];
  }

  int getValue(Point point) {
    return content[point.x][point.y];
  }

  List<Point> _empty() {
    List<Point> points = [];
    for (int i = 0; i < question.length; i++) {
      for (int j = 0; j < question[i].length; j++) {
        if (question[i][j] == 0) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  List<Point> _highlight() {
    if (content[selected.x][selected.y] == 0) {
      return [];
    }
    List<Point> points = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if ((i != selected.x && j != selected.y) && content[selected.x][selected.y] == content[i][j]) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  List<Point> _related() {
    List<Point> relatedList = [];
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == selected.x && j == selected.y) {
          continue;
        }
        if (i == selected.x || j == selected.y) {
          relatedList.add(Point.from(i, j));
        }
      }
    }
    return relatedList;
  }

  List<List<int>> toSudokuArray(String string) {
    final List<String> firstChunk = string.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<int> _toInt(String string) {
    return string.split("").map((e) => e.toInt()).toList();
  }
}

final sudokuRecordNotifier =
    ChangeNotifierProvider.autoDispose.family<SudokuRecordNotifier, SudokuInputLog>((ref, sudokuInputLog) {
  return SudokuRecordNotifier(sudokuInputLog)..init();
});
