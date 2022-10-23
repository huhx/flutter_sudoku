import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

import 'sudoku_point.dart';

class SudokuInfo extends Equatable {
  final List<List<int>> question;
  final List<List<int>> answer;
  final Difficulty difficulty;
  final String dateTime;

  const SudokuInfo({
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.dateTime,
  });

  bool hasValue(Point point) {
    return question[point.x][point.y] != 0;
  }

  List<List<int>> deepCopy() {
    return question.map((e) => e.toList()).toList();
  }

  List<Point> empty() {
    List<Point> points = [];
    for (int i = 0; i < question.length; i++) {
      for (int j = 0; j < question[i].length; j++) {
        if (question[i][j] == 0) {
          points.add(Point(x: i, y: j));
        }
      }
    }
    return points;
  }

  bool checkValue(Point point, int value) {
    return answer[point.x][point.y] == value;
  }

  bool hasNoValue(Point point) {
    return question[point.x][point.y] == 0;
  }

  bool isSuccess(List<List<int>> content) {
    for (int i = 0; i < content.length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        final int actual = content[i][j], expect = answer[i][j];
        if (actual != expect) {
          return false;
        }
      }
    }
    return true;
  }

  int correctValue(Point point) {
    return answer[point.x][point.y];
  }

  List<SudokuCheck> check(List<List<int>> content) {
    final int length = content.length;
    List<SudokuCheck> result = [];

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < content[i].length; j++) {
        final int actual = content[i][j], expect = answer[i][j];
        if (actual != 0 && actual != expect) {
          result.add(SudokuCheck(x: i, y: j, actual: actual, expect: expect));
        }
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [question, answer, difficulty, dateTime];
}

class SudokuCheck extends Equatable {
  final int x;
  final int y;
  final int actual;
  final int expect;

  const SudokuCheck({
    required this.x,
    required this.y,
    required this.actual,
    required this.expect,
  });

  @override
  List<Object?> get props => [x, y, actual, expect];
}
