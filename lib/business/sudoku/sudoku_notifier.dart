import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late SudokuInfo sudoku;

  late Map<Point, Color> textColorMap;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;
  late Map<Point, List<int>?> notesMap;

  late Point selectPoint;
  late SudokuContent sudokuContent;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    textColorMap = {};
    notesMap = {};
    gameStatus = GameStatus.running;
    retryCount = 0;
    selectPoint = Point.first();
    tipCount = sudokuConfig.tipCount;
    enableNotes = false;

    state = ResultState.loading();
    sudoku = await sudokuApi.getSudokuData(dateTime, difficulty);

    sudokuContent = SudokuContent(content: sudoku.deepCopy());

    // input text color
    sudoku.empty().forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(Point point) {
    if (point == selectPoint) {
      return selectedColor;
    }

    final List<Point> highlightPoints = sudokuContent.highlight(selectPoint);
    if (highlightPoints.contains(point)) {
      return highlightColor;
    }

    final List<Point> relatedPoints = sudokuContent.related(selectPoint);
    if (relatedPoints.contains(point)) {
      return relatedColor;
    }
    return null;
  }

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  bool get isNotCorrect => !isCorrect;

  bool get isCorrect {
    final int value = sudokuContent.getValue(selectPoint);
    return sudoku.checkValue(selectPoint, value);
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/${sudokuConfig.retryCount}";
  }

  List<int>? noteValue(Point point) {
    return notesMap[point];
  }

  Future<void> refresh(DateTime dateTime, Difficulty difficulty) async {
    await init(dateTime, difficulty);
  }

  void onTapped(Point point) {
    selectPoint = point;

    notifyListeners();
  }

  String get dateString {
    return sudoku.dateTime.toString();
  }

  int getValue(Point point) {
    return sudokuContent.getValue(point);
  }

  Difficulty get difficulty => sudoku.difficulty;

  GameStatus onInput(int value) {
    if (sudoku.hasValue(selectPoint) || isCorrect) {
      return gameStatus;
    }

    if (enableNotes) {
      final List<int>? list = notesMap[selectPoint];
      if (list == null || list.isEmpty) {
        notesMap[selectPoint] = [value];
      } else {
        notesMap[selectPoint] = list.addOrRemove(value);
      }
      sudokuContent.update(selectPoint, 0);

      notifyListeners();
      return gameStatus;
    }

    notesMap.remove(selectPoint);
    sudokuContent.update(selectPoint, value);

    if (isNotCorrect) {
      textColorMap[selectPoint] = errorColor;
      retryCount = retryCount + 1;
      if (retryCount >= sudokuConfig.retryCount) {
        gameStatus = GameStatus.failed;
      }
    } else {
      textColorMap[selectPoint] = inputColor;

      if (sudoku.isSuccess(sudokuContent.content)) {
        gameStatus = GameStatus.success;
      }
    }

    notifyListeners();
    return gameStatus;
  }

  void useTip() {
    if (isNotCorrect) {
      textColorMap[selectPoint] = inputColor;

      sudokuContent.update(selectPoint, sudoku.correctValue(selectPoint));
      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void toggleNote() {
    enableNotes = !enableNotes;

    notifyListeners();
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  final SudokuNotifier sudokuNotifier = SudokuNotifier();
  sudokuNotifier.init(request.dateTime, request.difficulty);
  return sudokuNotifier;
});
