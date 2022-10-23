import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_content.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late GameStatus gameStatus;
  late int retryCount;
  late int tipCount;

  late Sudoku sudoku;

  ResultState state = ResultState.success();

  Future<void> init(DateTime dateTime, Difficulty difficulty) async {
    gameStatus = GameStatus.running;
    retryCount = 0;
    tipCount = sudokuConfig.tipCount;

    state = ResultState.loading();
    final SudokuResponse sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);
    sudoku = Sudoku.from(sudokuResponse)..initColor();

    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(Point point) {
    return sudoku.sudokuColor.getColor(point);
  }

  Color? getTextColor(Point point) {
    return sudoku.sudokuColor.getTextColor(point);
  }

  bool get enableNotes => sudoku.enableNotes;

  bool get isNotCorrect => !isCorrect;

  bool get isCorrect => sudoku.checkValue();

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/${sudokuConfig.retryCount}";
  }

  List<int>? noteValue(Point point) {
    return sudoku.getNoteValue(point);
  }

  Future<void> refresh(DateTime dateTime, Difficulty difficulty) async {
    await init(dateTime, difficulty);
  }

  void onTapped(Point point) {
    sudoku.setSelected(point);

    notifyListeners();
  }

  String get dateString => sudoku.dateTime;

  int getValue(Point point) {
    return sudoku.getValue(point);
  }

  Difficulty get difficulty => sudoku.difficulty;

  GameStatus onInput(int value) {
    if (sudoku.hasValue() || isCorrect) {
      return gameStatus;
    }

    if (sudoku.enableNotes) {
      sudoku.updateNotesMap(value);
      sudoku.update(0);
      sudoku.sudokuColor.putHighlightColor([]);

      notifyListeners();
      return gameStatus;
    }

    sudoku.removeNote();
    sudoku.update(value);
    sudoku.sudokuColor.putRelatedColor(sudoku.related());
    sudoku.sudokuColor.putHighlightColor(sudoku.highlight());

    if (isNotCorrect) {
      sudoku.sudokuColor.putTextColor(errorColor);
      retryCount = retryCount + 1;
      if (retryCount >= sudokuConfig.retryCount) {
        gameStatus = GameStatus.failed;
      }
    } else {
      sudoku.sudokuColor.putTextColor(inputColor);
      if (sudoku.isSuccess()) {
        gameStatus = GameStatus.success;
      }
    }

    notifyListeners();
    return gameStatus;
  }

  void useTip() {
    if (isNotCorrect) {
      sudoku.update(sudoku.correctValue());
      sudoku.removeNote();

      sudoku.sudokuColor.putTextColor(inputColor);
      sudoku.sudokuColor.putHighlightColor(sudoku.highlight());

      tipCount = tipCount - 1;

      notifyListeners();
    }
  }

  void toggleNote() {
    sudoku.toggleNote();

    notifyListeners();
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  final SudokuNotifier sudokuNotifier = SudokuNotifier();
  sudokuNotifier.init(request.dateTime, request.difficulty);
  return sudokuNotifier;
});
