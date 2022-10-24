import 'package:equatable/equatable.dart';

import 'sudoku.dart';

class SudokuRecord extends Equatable {
  final int? id;
  final int year;
  final int month;
  final int day;
  final Difficulty difficulty;
  final GameStatus status;
  final int duration;
  final int tips;
  final int startTime;
  final int endTime;
  final int createTime;

  @override
  List<Object?> get props => [id, year, month, day, difficulty, status, duration, createTime];

  const SudokuRecord({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.difficulty,
    required this.status,
    required this.duration,
    required this.tips,
    required this.startTime,
    required this.endTime,
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
      'tips': tips,
      'startTime': startTime,
      'endTime': endTime,
      'createTime': createTime,
    };
  }

  factory SudokuRecord.fromJson(Map<String, dynamic> json) {
    return SudokuRecord(
      id: json['id'] as int?,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      difficulty: Difficulty.from(json['difficulty'] as int),
      status: GameStatus.values.byName(json['status'] as String),
      duration: json['duration'] as int,
      tips: json['tips'] as int,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      createTime: json['createTime'] as int,
    );
  }
}