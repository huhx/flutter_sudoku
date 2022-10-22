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

  late Map<Point, Color> textColorMap;

  late ChangeStack changeStack;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;
  late Map<Point, List<int>?> notesMap;

  late Point selectPoint;
  late List<List<int>> content;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    changeStack = ChangeStack();

    textColorMap = {};
    notesMap = {};
    gameStatus = GameStatus.running;
    retryCount = 0;
    selectPoint = Point.first();
    tipCount = 2;
    enableNotes = false;

    state = ResultState.loading();
    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    content = sudokuResponse.fromQuestion();

    // input text color
    ListUtil.empty(sudokuResponse.fromQuestion()).forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(int row, int column) {
    final Point point = Point.from(row, column);

    final Map<Point, Color> selectColorMap = {selectPoint: selectedColor};
    final Map<Point, Color> highlightColorMap = _highlight();
    final Map<Point, Color> relatedColorMap = _related();

    return {...highlightColorMap, ...relatedColorMap, ...selectColorMap}[point];
  }

  Color? getTextColor(int row, int column) {
    return textColorMap[Point(x: row, y: column)];
  }

  bool get isNotCorrect {
    return content[selectPoint.x][selectPoint.y] != sudokuResponse.fromAnswer()[selectPoint.x][selectPoint.y];
  }

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
    selectPoint = Point.from(row, column);

    notifyListeners();
  }

  String get dateString {
    return sudokuResponse.dateTime.toString();
  }

  Difficulty get difficulty => sudokuResponse.difficulty;

  GameStatus onInput(int value) {
    int tappedX = selectPoint.x;
    int tappedY = selectPoint.y;
    if (sudokuResponse.fromQuestion()[tappedX][tappedY] != 0) {
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

      if (ListUtil.check(content, sudokuResponse.fromAnswer())) {
        gameStatus = GameStatus.success;
      }
    }

    notifyListeners();

    return gameStatus;
  }

  Map<Point, Color> _highlight() {
    int tappedX = selectPoint.x;
    int tappedY = selectPoint.y;
    final List<Point> matchedPoints = ListUtil.match(content, tappedX, tappedY);
    return {for (var point in matchedPoints) point: highlightColor};
  }

  void useTip() {
    int tappedX = selectPoint.x;
    int tappedY = selectPoint.y;

    if (isNotCorrect) {
      textColorMap[selectPoint] = inputColor;

      content[tappedX][tappedY] = sudokuResponse.fromAnswer()[tappedX][tappedY];
      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    int tappedX = selectPoint.x;
    int tappedY = selectPoint.y;

    if (sudokuResponse.fromQuestion()[tappedX][tappedY] == 0 && isNotCorrect) {
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
    selectPoint = Point.from(sudokuStack.row, sudokuStack.column);

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
    int tappedX = selectPoint.x;
    int tappedY = selectPoint.y;

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
