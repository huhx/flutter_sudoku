import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:flutter_sudoku/util/list_util.dart';
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
    return !sudoku.checkPoint(selectPoint, sudokuContent.fromPoint(selectPoint));
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
    if (sudoku.hasValue(selectPoint) || !isNotCorrect) {
      return gameStatus;
    }

    if (enableNotes) {
      if (isNotCorrect) {
        final List<int>? list = notesMap[selectPoint];
        if (list == null || list.isEmpty) {
          notesMap[selectPoint] = [value];
        } else {
          if (list.contains(value)) {
            list.remove(value);
          } else {
            list.add(value);
          }
          notesMap[selectPoint] = list;
        }
        sudokuContent.update(selectPoint, 0);

        notifyListeners();
      }
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

  void toggleNote() {
    enableNotes = !enableNotes;

    notifyListeners();
  }

  Map<Point, Color> _related() {
    Map<Point, Color> relatedColorMap = {};
    for (int i = 0; i < sudokuContent.content.length; i++) {
      for (int j = 0; j < sudokuContent.content[i].length; j++) {
        if (i == selectPoint.x && j == selectPoint.y) {
          continue;
        }
        if (i == selectPoint.x || j == selectPoint.y) {
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
