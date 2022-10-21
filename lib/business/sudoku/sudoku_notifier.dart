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
  late Map<Point, Color?> colorMap;
  late Map<Point, Color?> textColorMap;
  late Map<Point, Color?> highlightColorMap;
  late Map<Point, Color?> relatedColorMap;

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

  void init(DateTime dateTime, Difficulty difficulty) async {
    this.dateTime = dateTime;
    this.difficulty = difficulty;
    changeStack = ChangeStack();

    colorMap = {};
    textColorMap = {};
    notesMap = {};
    highlightColorMap = {};
    relatedColorMap = {};
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = 2;
    enableNotes = false;

    state = ResultState.loading();
    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    question = sudokuResponse.fromQuestion();
    content = sudokuResponse.fromQuestion();
    answer = sudokuResponse.fromAnswer();

    // selected
    colorMap[Point.first()] = selectedColor;

    // background color
    highlightColorMap = ListUtil.highlight(content, 0, 0);

    // input text color
    ListUtil.empty(question).forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(int row, int column) {
    return {...highlightColorMap, ...relatedColorMap, ...colorMap}[Point(x: row, y: column)];
  }

  Color? getTextColor(int row, int column) {
    return textColorMap[Point(x: row, y: column)];
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/3";
  }

  List<int>? noteValue(int row, int column) {
    return notesMap[Point(x: row, y: column)];
  }

  void refresh(DateTime dateTime, Difficulty difficulty) {
    init(dateTime, difficulty);
  }

  void onTapped(int row, int column) {
    tappedX = row;
    tappedY = column;

    // selectedColor
    colorMap = {Point(x: row, y: column): selectedColor};

    // highlightColor color
    highlightColorMap = ListUtil.highlight(content, row, column);

    // related color
    relatedColorMap = _buildRelateColorMap(row, column);

    notifyListeners();
  }

  GameStatus onInput(int value) {
    if (question[tappedX][tappedY] != 0) {
      return gameStatus;
    }

    if (enableNotes) {
      changeStack.add(row: tappedX, column: tappedY, isNote: true, newValue: value);

      if (content[tappedX][tappedY] != answer[tappedX][tappedY]) {
        final List<int>? list = notesMap[Point(x: tappedX, y: tappedY)];
        notesMap[Point(x: tappedX, y: tappedY)] = [...?list, value];

        content[tappedX][tappedY] = 0;
        highlightColorMap = {};

        notifyListeners();
      }
      return gameStatus;
    }
    changeStack.add(row: tappedX, column: tappedY, isNote: false, newValue: value);

    content[tappedX][tappedY] = value;
    if (answer[tappedX][tappedY] != value) {
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

    // highlightColor color
    highlightColorMap = ListUtil.highlight(content, tappedX, tappedY);

    notifyListeners();

    return gameStatus;
  }

  void useTip() {
    if (content[tappedX][tappedY] != answer[tappedX][tappedY]) {
      textColorMap[Point(x: tappedX, y: tappedY)] = inputColor;

      content[tappedX][tappedY] = answer[tappedX][tappedY];
      highlightColorMap = ListUtil.highlight(content, tappedX, tappedY);

      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    if (question[tappedX][tappedY] == 0 && (content[tappedX][tappedY] != answer[tappedX][tappedY])) {
      highlightColorMap = {};

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
    colorMap = {Point(x: sudokuStack.row, y: sudokuStack.column): selectedColor};
    relatedColorMap = _buildRelateColorMap(tappedX, tappedY);

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
      if (answer[sudokuStack.row][sudokuStack.column] != sudokuStack.oldValue) {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = errorColor;
      } else {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = inputColor;
      }
      highlightColorMap = ListUtil.highlight(content, tappedX, tappedY);
    }

    notifyListeners();

    return gameStatus;
  }

  Map<Point, Color?> _buildRelateColorMap(int row, int column) {
    Map<Point, Color?> relatedColorMap = {};
    final Set<Point> relatedPoints = ListUtil.related(row, column);
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == row && j == column) {
          continue;
        }
        if (i == row || j == column) {
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
