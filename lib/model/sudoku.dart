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
}

class SudokuResponse extends Equatable {
  final List<List<int>> data;

  const SudokuResponse({required this.data});

  @override
  List<Object?> get props => [data];

  factory SudokuResponse.fromJson(Map<String, dynamic> json) {
    return SudokuResponse(data: json['data'] as List<List<int>>);
  }
}
