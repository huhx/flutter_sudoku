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

  static Difficulty? next(Difficulty difficulty) {
    if (difficulty.level + 1 > Difficulty.s.level) {
      return null;
    }
    return Difficulty.from(difficulty.level + 1);
  }
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

  List<List<int>> toQuestion() {
    final List<String> firstChunk = question.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<List<int>> toAnswer() {
    final List<String> firstChunk = answer.chunk(9);
    return firstChunk.map((e) => _toInt(e)).toList();
  }

  List<int> _toInt(String string) {
    return string.split("").map((e) => e.toInt()).toList();
  }
}

enum GameStatus {
  success('成功'),
  running('运行'),
  failed('失败');

  final String label;

  const GameStatus(this.label);
}
