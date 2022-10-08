import 'package:equatable/equatable.dart';

import 'sudoku.dart';

class SudokuRecord extends Equatable {
  final String id;
  final int year;
  final int month;
  final int day;
  final Difficulty difficulty;
  final SudokuStatus status;
  final int duration;
  final int createTime;

  @override
  List<Object?> get props => [id, year, month, day, difficulty, status, duration, createTime];

  const SudokuRecord({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.difficulty,
    required this.status,
    required this.duration,
    required this.createTime,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'difficulty': difficulty.level,
      'status': status.name,
      'duration': duration,
      'createTime': createTime,
    };
  }

  factory SudokuRecord.fromJson(Map<String, dynamic> json) {
    return SudokuRecord(
      id: json['id'] as String,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      difficulty: Difficulty.from(json['difficulty'] as int),
      status: SudokuStatus.values.byName(json['status'] as String),
      duration: json['duration'] as int,
      createTime: json['createTime'] as int,
    );
  }
}

enum SudokuStatus { pause, success }
