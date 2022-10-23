import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_stack.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:flutter_sudoku/util/list_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late SudokuInfo sudoku;

  late Map<Point, Color> textColorMap;

  late ChangeStack changeStack;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;
  late Map<Point, List<int>?> notesMap;

  late Point selectPoint;
  late SudokuContent sudokuContent;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    changeStack = ChangeStack();

    textColorMap = {};
    notesMap = {};
    gameStatus = GameStatus.running;
    retryCount = 0;
    selectPoint = Point.first();
    tipCount = sudokuConfig.tipCount;
    enableNotes = false;

    state = ResultState.loading();
    sudoku = await sudokuApi.getSudokuData(dateTime, difficulty);

    sudokuContent = SudokuContent(content: sudoku.question);

    // input text color
    sudoku.empty().forEach((element) {
      textColorMap[element] = inputColor;
    });

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(Point point) {
    final Map<Point, Color> selectColorMap = {selectPoint: selectedColor};
    final Map<Point, Color> highlightColorMap = _highlight();
    final Map<Point, Color> relatedColorMap = _related();

    return {...highlightColorMap, ...relatedColorMap, ...selectColorMap}[point];
  }

  BoxBorder getBorder(Point point) {
    const BorderSide borderSide = BorderSide(color: Colors.blue, width: 2.0);
    final List<int> columnIndexes = [0, 3, 6];
    final List<int> rowIndexes = [0, 3, 6];
    BorderSide top = BorderSide.none, bottom = BorderSide.none, left = BorderSide.none, right = BorderSide.none;

    if (columnIndexes.contains(point.y)) {
      left = borderSide;
    } else {
      left = const BorderSide(color: Colors.grey);
    }

    if (rowIndexes.contains(point.x)) {
      top = borderSide;
    } else {
      top = const BorderSide(color: Colors.grey);
    }

    if (point.y == 8) {
      right = borderSide;
    }

    if (point.x == 8) {
      bottom = borderSide;
    }

    return Border(top: top, bottom: bottom, left: left, right: right);
  }

  Color? getTextColor(Point point) {
    return textColorMap[point];
  }

  bool get isNotCorrect {
    return sudoku.checkPoint(selectPoint, sudokuContent.fromPoint(selectPoint));
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

  int valueFromPoint(Point point) {
    return sudokuContent.fromPoint(point);
  }

  Difficulty get difficulty => sudoku.difficulty;

  GameStatus onInput(int value) {
    if (sudoku.hasValue(selectPoint)) {
      return gameStatus;
    }

    if (enableNotes) {
      changeStack.add(point: selectPoint, isNote: true, newValue: value);

      if (isNotCorrect) {
        final List<int>? list = notesMap[selectPoint];
        notesMap[selectPoint] = [...?list, value];

        sudokuContent.update(selectPoint, 0);

        notifyListeners();
      }
      return gameStatus;
    }
    changeStack.add(point: selectPoint, isNote: false, newValue: value);

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

  Map<Point, Color> _highlight() {
    final List<Point> matchedPoints = ListUtil.match(sudokuContent.content, selectPoint);
    return {for (var point in matchedPoints) point: highlightColor};
  }

  void useTip() {
    if (isNotCorrect) {
      textColorMap[selectPoint] = inputColor;

      sudokuContent.update(selectPoint, sudoku.correctValue(selectPoint));
      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void clear() {
    if (sudoku.hasNoValue(selectPoint) && isNotCorrect) {
      sudokuContent.update(selectPoint, 0);

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
    selectPoint = sudokuStack.point;

    if (sudokuStack.isNote) {
      if (sudokuStack.oldValue == 0) {
        notesMap.remove(selectPoint);
      } else {
        final List<int>? list = notesMap[selectPoint];
        list?.removeLast();
        notesMap[selectPoint] = list;
        if (list == null || list.isEmpty) {
          sudokuContent.update(selectPoint, sudokuStack.oldValue);
        }
      }
    } else {
      sudokuContent.update(selectPoint, sudokuStack.oldValue);
      if (isNotCorrect) {
        textColorMap[selectPoint] = errorColor;
      } else {
        textColorMap[selectPoint] = inputColor;
      }
    }

    notifyListeners();

    return gameStatus;
  }

  Map<Point, Color> _related() {
    Map<Point, Color> relatedColorMap = {};
    final Set<Point> relatedPoints = ListUtil.related(selectPoint.x, selectPoint.y);
    for (int i = 0; i < sudokuContent.content.length; i++) {
      for (int j = 0; j < sudokuContent.content[i].length; j++) {
        if (i == selectPoint.x && j == selectPoint.y) {
          continue;
        }
        if (i == selectPoint.x || j == selectPoint.y) {
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
