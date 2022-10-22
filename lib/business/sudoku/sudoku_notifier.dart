import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_stack.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:flutter_sudoku/util/list_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late SudokuResponse sudokuResponse;
  late DateTime dateTime;
  late Difficulty difficulty;

  late Map<Point, Color> textColorMap;

  late ChangeStack changeStack;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;
  late Map<Point, List<int>?> notesMap;

  int tappedX = 0, tappedY = 0;
  late List<List<int>> question;
  late List<List<int>> content;
  late List<List<int>> answer;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    this.dateTime = dateTime;
    this.difficulty = difficulty;
    changeStack = ChangeStack();

    textColorMap = {};
    notesMap = {};
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = 2;
    enableNotes = false;

    state = ResultState.loading();
    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    question = sudokuResponse.fromQuestion();
    content = sudokuResponse.fromQuestion();
    answer = sudokuResponse.fromAnswer();

    // input text color
    ListUtil.empty(question).forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(int row, int column) {
    final Map<Point, Color> selectColorMap = {Point(x: tappedX, y: tappedY): selectedColor};
    final Map<Point, Color> highlightColorMap = _highlight();
    final Map<Point, Color> relatedColorMap = _related();

    return {...highlightColorMap, ...relatedColorMap, ...selectColorMap}[Point(x: row, y: column)];
  }

  Color? getTextColor(int row, int column) {
    return textColorMap[Point(x: row, y: column)];
  }

  bool get isNotCorrect => content[tappedX][tappedY] != answer[tappedX][tappedY];

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/3";
  }

  List<int>? noteValue(int row, int column) {
    return notesMap[Point(x: row, y: column)];
  }

  Future<void> refresh(DateTime dateTime, Difficulty difficulty) async {
    await init(dateTime, difficulty);
  }

  void onTapped(int row, int column) {
    tappedX = row;
    tappedY = column;

    notifyListeners();
  }

  GameStatus onInput(int value) {
    if (question[tappedX][tappedY] != 0) {
      return gameStatus;
    }

    if (enableNotes) {
      changeStack.add(row: tappedX, column: tappedY, isNote: true, newValue: value);

      if (isNotCorrect) {
        final List<int>? list = notesMap[Point(x: tappedX, y: tappedY)];
        notesMap[Point(x: tappedX, y: tappedY)] = [...?list, value];

        content[tappedX][tappedY] = 0;

        notifyListeners();
      }
      return gameStatus;
    }
    changeStack.add(row: tappedX, column: tappedY, isNote: false, newValue: value);

    content[tappedX][tappedY] = value;
    if (isNotCorrect) {
      textColorMap[Point(x: tappedX, y: tappedY)] = errorColor;
      retryCount = retryCount + 1;
      if (retryCount >= 3) {
        gameStatus = GameStatus.failed;
      }
    } else {
      textColorMap[Point(x: tappedX, y: tappedY)] = inputColor;

      if (ListUtil.check(content, answer)) {
        gameStatus = GameStatus.success;
      }
    }

    notifyListeners();

    return gameStatus;
  }

  Map<Point, Color> _highlight() {
    final List<Point> matchedPoints = ListUtil.match(content, tappedX, tappedY);
    return {for (var point in matchedPoints) point: highlightColor};
  }

  void useTip() {
    if (isNotCorrect) {
      textColorMap[Point(x: tappedX, y: tappedY)] = inputColor;

      content[tappedX][tappedY] = answer[tappedX][tappedY];
      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    if (question[tappedX][tappedY] == 0 && isNotCorrect) {
      content[tappedX][tappedY] = 0;

      notifyListeners();
    }
  }

  void toggleNote() {
    enableNotes = !enableNotes;

    notifyListeners();
  }

  GameStatus undo() {
    if (changeStack.isEmpty) {
      return gameStatus;
    }

    final SudokuStack sudokuStack = changeStack.undo();
    tappedX = sudokuStack.row;
    tappedY = sudokuStack.column;

    if (sudokuStack.isNote) {
      if (sudokuStack.oldValue == 0) {
        notesMap.remove(Point(x: sudokuStack.row, y: sudokuStack.column));
      } else {
        final List<int>? list = notesMap[Point(x: sudokuStack.row, y: sudokuStack.column)];
        list?.removeLast();
        notesMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = list;
        if (list == null || list.isEmpty) {
          content[sudokuStack.row][sudokuStack.column] = sudokuStack.oldValue;
        }
      }
    } else {
      content[sudokuStack.row][sudokuStack.column] = sudokuStack.oldValue;
      if (isNotCorrect) {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = errorColor;
      } else {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = inputColor;
      }
    }

    notifyListeners();

    return gameStatus;
  }

  Map<Point, Color> _related() {
    Map<Point, Color> relatedColorMap = {};
    final Set<Point> relatedPoints = ListUtil.related(tappedX, tappedY);
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == tappedX && j == tappedY) {
          continue;
        }
        if (i == tappedX || j == tappedY) {
          relatedColorMap[Point(x: i, y: j)] = relatedColor;
        }
        if (relatedPoints.contains(Point(x: i, y: j))) {
          relatedColorMap[Point(x: i, y: j)] = relatedColor;
        }
      }
    }
    return relatedColorMap;
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  final SudokuNotifier sudokuNotifier = SudokuNotifier();
  sudokuNotifier.init(request.dateTime, request.difficulty);
  return sudokuNotifier;
});
