import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/common/string_extension.dart';

class SudokuRequest extends Equatable {
  final Difficulty difficulty;
  final int year;
  final int month;
  final int day;

  const SudokuRequest({
    required this.difficulty,
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  List<Object?> get props => [difficulty, year, month, day];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nd': difficulty.level,
      'y': year,
      'm': month,
      'd': day,
    };
  }
}

enum Difficulty {
  d(0, "入门"),
  c(1, "初级"),
  b(2, "中级"),
  a(3, "高级"),
  s(4, "骨灰级");

  final int level;
  final String label;

  const Difficulty(this.level, this.label);

  static Difficulty from(int level) {
    return Difficulty.values.firstWhere((element) => element.level == level);
  }
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

class SudokuResponse extends Equatable {
  final String question;
  final String answer;
  final Difficulty difficulty;

  const SudokuResponse({
    required this.question,
    required this.answer,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [question, answer, difficulty];

  List<List<int>> fromQuestion() {
    final List<String> firstChunk = question.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<List<int>> fromAnswer() {
    final List<String> firstChunk = answer.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<SudokuCheck> check(List<List<int>> userAnswer) {
    final List<List<int>> answer = fromAnswer();
    final int length = userAnswer.length;
    List<SudokuCheck> result = [];

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < userAnswer[i].length; j++) {
        final int actual = userAnswer[i][j], expect = answer[i][j];
        if (actual != 0 && actual != expect) {
          result.add(SudokuCheck(x: i, y: j, actual: actual, expect: expect));
        }
      }
    }
    return result;
  }

  List<int> _toInt(String string) {
    return string.split("").map((e) => e.toInt()).toList();
  }
}
