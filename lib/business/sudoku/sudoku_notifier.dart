import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_color.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_content.dart';
import 'package:flutter_sudoku/model/sudoku_info.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late SudokuInfo sudoku;
  late SudokuColor sudokuColor;

  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late bool enableNotes;

  late Point selectPoint;
  late SudokuContent sudokuContent;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    gameStatus = GameStatus.running;
    retryCount = 0;
    selectPoint = Point.first();
    tipCount = sudokuConfig.tipCount;
    enableNotes = false;

    state = ResultState.loading();
    sudoku = await sudokuApi.getSudokuData(dateTime, difficulty);
    sudokuContent = SudokuContent(content: sudoku.deepCopy(), notesMap: {});

    sudokuColor = SudokuColor(
      selected: selectPoint,
      highlightPoints: sudokuContent.highlight(selectPoint),
      relatedPoints: sudokuContent.related(selectPoint),
      textColorMap: {for (var point in sudoku.empty()) point: inputColor},
    );

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(Point point) {
    return sudokuColor.getColor(point);
  }

  Color? getTextColor(Point point) {
    return sudokuColor.getTextColor(point);
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
    return sudokuContent.getNoteValue(point);
  }

  Future<void> refresh(DateTime dateTime, Difficulty difficulty) async {
    await init(dateTime, difficulty);
  }

  void onTapped(Point point) {
    selectPoint = point;
    sudokuColor.update(
      selected: point,
      highlightPoints: sudokuContent.highlight(point),
      relatedPoints: sudokuContent.related(point),
    );

    notifyListeners();
  }

  String get dateString => sudoku.dateTime.toString();

  int getValue(Point point) {
    return sudokuContent.getValue(point);
  }

  Difficulty get difficulty => sudoku.difficulty;

  GameStatus onInput(int value) {
    if (sudoku.hasValue(selectPoint) || isCorrect) {
      return gameStatus;
    }

    if (enableNotes) {
      sudokuContent.updateNotesMap(selectPoint, value);
      sudokuContent.update(selectPoint, 0);
      sudokuColor.putHighlightColor([]);

      notifyListeners();
      return gameStatus;
    }

    sudokuContent.removeNote(selectPoint);
    sudokuContent.update(selectPoint, value);
    sudokuColor.putRelatedColor(sudokuContent.related(selectPoint));
    sudokuColor.putHighlightColor(sudokuContent.highlight(selectPoint));

    if (isNotCorrect) {
      sudokuColor.putTextColor(selectPoint, errorColor);
      retryCount = retryCount + 1;
      if (retryCount >= sudokuConfig.retryCount) {
        gameStatus = GameStatus.failed;
      }
    } else {
      sudokuColor.putTextColor(selectPoint, inputColor);
      if (sudoku.isSuccess(sudokuContent.content)) {
        gameStatus = GameStatus.success;
      }
    }

    notifyListeners();
    return gameStatus;
  }

  void useTip() {
    if (isNotCorrect) {
      sudokuContent.update(selectPoint, sudoku.correctValue(selectPoint));
      sudokuContent.removeNote(selectPoint);

      sudokuColor.putTextColor(selectPoint, inputColor);
      sudokuColor.putHighlightColor(sudokuContent.highlight(selectPoint));

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
