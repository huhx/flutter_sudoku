import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/common/string_extension.dart';

class SudokuRequest extends Equatable {
  final DateTime dateTime;
  final Difficulty difficulty;

  @override
  List<Object?> get props => [dateTime, difficulty];

  const SudokuRequest({
    required this.dateTime,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dateTime': dateTime,
      'difficulty': difficulty.level,
    };
  }

  Map<String, dynamic> toRequest() {
    return <String, dynamic>{
      'year': dateTime.year,
      'month': dateTime.month,
      'day': dateTime.day,
      'difficulty': difficulty.level,
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
  final String dateTime;

  const SudokuResponse({
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.dateTime,
  });

  SudokuInfo toSudoku() {
    return SudokuInfo(
      question: fromQuestion(),
      answer: fromAnswer(),
      difficulty: difficulty,
      dateTime: dateTime,
    );
  }

  @override
  List<Object?> get props => [question, answer, difficulty, dateTime];

  factory SudokuResponse.fromJson(Map<String, dynamic> json) {
    return SudokuResponse(
      question: json['question'] as String,
      answer: json['answer'] as String,
      difficulty: Difficulty.from(json['difficulty'] as int),
      dateTime: json['dateTime'] as String,
    );
  }

  List<List<int>> fromQuestion() {
    final List<String> firstChunk = question.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<List<int>> fromAnswer() {
    final List<String> firstChunk = answer.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<int> _toInt(String string) {
    return string.split("").map((e) => e.toInt()).toList();
  }
}

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

  bool checkPoint(Point point, int value) {
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

class Point extends Equatable {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  factory Point.first() {
    return const Point(x: 0, y: 0);
  }

  factory Point.from(int x, int y) {
    return Point(x: x, y: y);
  }

  @override
  List<Object?> get props => [x, y];
}

class SudokuContent {
  final List<List<int>> content;

  const SudokuContent({required this.content});

  SudokuContent update(Point point, int value) {
    content[point.x][point.y] = value;
    return this;
  }

  int fromPoint(Point point) {
    return content[point.x][point.y];
  }
}

enum GameStatus { success, running, failed }
