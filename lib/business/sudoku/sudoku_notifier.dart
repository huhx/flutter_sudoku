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

  late ChangeStack changeStack;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;
  late Map<Point, int> notesMap;

  late int tappedX, tappedY;
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
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = 2;
    enableNotes = false;
    tappedX = 0;
    tappedY = 0;

    state = ResultState.loading();
    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);

    question = sudokuResponse.fromQuestion();
    content = sudokuResponse.fromQuestion();
    answer = sudokuResponse.fromAnswer();

    // background color
    if (content[0][0] == 0) {
      colorMap[Point.first()] = selectedColor;
    } else {
      colorMap[Point.first()] = selectedColor;
      final List<Point> matchedPoints = ListUtil.match(content, 0, 0);
      for (final Point point in matchedPoints) {
        highlightColorMap[point] = highlightColor;
      }
    }

    // input text color
    ListUtil.empty(question).forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(int row, int column) {
    return {...colorMap, ...highlightColorMap}[Point(x: row, y: column)];
  }

  Color? getTextColor(int row, int column) {
    return textColorMap[Point(x: row, y: column)];
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/3";
  }

  int? noteValue(int row, int column) {
    return notesMap[Point(x: row, y: column)];
  }

  void refresh(DateTime dateTime, Difficulty difficulty) {
    init(dateTime, difficulty);
  }

  void onTapped(int row, int column) {
    colorMap.clear();
    highlightColorMap.clear();
    tappedX = row;
    tappedY = column;

    // selectedColor
    colorMap[Point(x: row, y: column)] = selectedColor;

    // highlightColor color
    if (content[row][column] != 0) {
      final List<Point> matchedPoints = ListUtil.match(content, row, column);
      for (final Point point in matchedPoints) {
        highlightColorMap[point] = highlightColor;
      }
    }

    // related color
    final Set<Point> relatedPoints = ListUtil.related(row, column);
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        if (i == row && j == column) {
          continue;
        }
        if (i == row || j == column) {
          colorMap[Point(x: i, y: j)] = relatedColor;
        }
        if (relatedPoints.contains(Point(x: i, y: j))) {
          colorMap[Point(x: i, y: j)] = relatedColor;
        }
      }
    }

    notifyListeners();
  }

  GameStatus onInput(int value) {
    if (question[tappedX][tappedY] != 0) {
      return gameStatus;
    }

    if (enableNotes) {
      final SudokuStack sudokuStack = SudokuStack(
        row: tappedX,
        column: tappedY,
        isNote: true,
        oldValue: content[tappedX][tappedY],
        newValue: value,
      );
      changeStack.add(sudokuStack);

      if (content[tappedX][tappedY] != answer[tappedX][tappedY]) {
        notesMap[Point(x: tappedX, y: tappedY)] = value;

        notifyListeners();
      }
      return gameStatus;
    }

    final SudokuStack sudokuStack = SudokuStack(
      row: tappedX,
      column: tappedY,
      isNote: false,
      oldValue: content[tappedX][tappedY],
      newValue: value,
    );

    changeStack.add(sudokuStack);

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
    highlightColorMap.clear();
    if (content[tappedX][tappedY] != 0) {
      final List<Point> matchedPoints = ListUtil.match(content, tappedX, tappedY);
      for (final Point point in matchedPoints) {
        highlightColorMap[point] = highlightColor;
      }
    }

    notifyListeners();

    return gameStatus;
  }

  void useTip() {
    if (content[tappedX][tappedY] != answer[tappedX][tappedY]) {
      textColorMap[Point(x: tappedX, y: tappedY)] = inputColor;

      content[tappedX][tappedY] = answer[tappedX][tappedY];
      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    if (question[tappedX][tappedY] == 0 && (content[tappedX][tappedY] != answer[tappedX][tappedY])) {
      colorMap.clear();
      colorMap[Point(x: tappedX, y: tappedY)] = selectedColor;

      final Set<Point> relatedPoints = ListUtil.related(tappedX, tappedY);

      for (int i = 0; i < content.length; i++) {
        for (int j = 0; j < content[i].length; j++) {
          if (i == tappedX && j == tappedY) {
            continue;
          }
          if (i == tappedX || j == tappedY) {
            colorMap[Point(x: i, y: j)] = relatedColor;
          }
          if (relatedPoints.contains(Point(x: i, y: j))) {
            colorMap[Point(x: i, y: j)] = relatedColor;
          }
        }
      }
      content[tappedX][tappedY] = 0;

      notifyListeners();
    }
  }

  void toggleNote() {
    enableNotes = !enableNotes;
    if (!enableNotes) {
      notesMap.clear();
    }

    notifyListeners();
  }

  GameStatus quickNote() {
    if (enableNotes && notesMap.isNotEmpty) {
      notesMap.forEach((point, value) {
        content[point.x][point.y] = value;
        if (answer[point.x][point.y] != value) {
          textColorMap[Point(x: point.x, y: point.y)] = errorColor;
          retryCount = retryCount + 1;
        } else {
          textColorMap[Point(x: point.x, y: point.y)] = inputColor;

          if (ListUtil.check(content, answer)) {
            gameStatus = GameStatus.success;
          }
        }
      });
      enableNotes = false;
      notesMap.clear();

      if (retryCount >= 3) {
        gameStatus = GameStatus.failed;
      }

      notifyListeners();
    }
    return gameStatus;
  }

  GameStatus undo() {
    if (changeStack.isEmpty) {
      return gameStatus;
    }

    final SudokuStack sudokuStack = changeStack.undo();
    if (sudokuStack.isNote) {
      if (sudokuStack.oldValue == 0) {
        notesMap.remove(Point(x: sudokuStack.row, y: sudokuStack.column));
      } else {
        notesMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = sudokuStack.oldValue;
      }
    } else {
      content[sudokuStack.row][sudokuStack.column] = sudokuStack.oldValue;
      if (answer[sudokuStack.row][sudokuStack.column] != sudokuStack.oldValue) {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = errorColor;
        retryCount += 1;
      } else {
        textColorMap[Point(x: sudokuStack.row, y: sudokuStack.column)] = inputColor;
      }
    }

    notifyListeners();
    return gameStatus;
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  final SudokuNotifier sudokuNotifier = SudokuNotifier();
  sudokuNotifier.init(request.dateTime, request.difficulty);
  return sudokuNotifier;
});