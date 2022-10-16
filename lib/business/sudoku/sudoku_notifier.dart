import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/common/result.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/theme/color.dart';
import 'package:flutter_sudoku/util/list_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuNotifier extends ChangeNotifier {
  late SudokuResponse sudokuResponse;
  late DateTime dateTime;
  late Difficulty difficulty;
  Map<Point, Color?> colorMap = {};

  bool isSuccess = false;
  bool isFailed = false;
  int retryCount = 0;

  int? tappedX, tappedY;
  late List<List<int>> content;

  ResultState state = ResultState.success();

  void init(DateTime dateTime, Difficulty difficulty) async {
    this.dateTime = dateTime;
    this.difficulty = difficulty;

    state = ResultState.loading();
    sudokuResponse = await sudokuApi.getSudokuData(dateTime, difficulty);
    content = sudokuResponse.fromQuestion();
    if (content[0][0] == 0) {
      colorMap[Point.first()] = selectedColor;
    } else {
      colorMap[Point.first()] = selectedColor;
      final List<Point> matchedPoints = ListUtil.match(content, content[0][0]);
      for (final Point point in matchedPoints) {
        colorMap[point] = selectedColor;
      }
    }
    state = ResultState.success();

    notifyListeners();
  }

  Color? getColor(int row, int column) {
    return colorMap[Point(x: row, y: column)];
  }

  String get retryString {
    return retryCount == 0 ? "检查无误" : "错误：$retryCount/3";
  }

  void refresh(DateTime dateTime, Difficulty difficulty) {
    init(dateTime, difficulty);
  }

  void onTapped(int row, int column) {
    tappedX = row;
    tappedY = column;
  }

  void onInput(int value) {
    if (sudokuResponse.fromQuestion()[tappedX!][tappedY!] != 0) {
      content[tappedX!][tappedY!] = value;
      notifyListeners();
    }
  }
}

final sudokuProvider = ChangeNotifierProvider.autoDispose.family<SudokuNotifier, SudokuRequest>((ref, request) {
  final SudokuNotifier sudokuNotifier = SudokuNotifier();
  sudokuNotifier.init(request.dateTime, request.difficulty);
  return sudokuNotifier;
});
