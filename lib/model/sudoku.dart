import 'package:equatable/equatable.dart';

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
  d(0),
  c(1),
  b(2),
  a(3),
  s(4);

  final int level;

  const Difficulty(this.level);

  static Difficulty from(int level) {
    return Difficulty.values.firstWhere((element) => element.level == level);
  }
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
}
