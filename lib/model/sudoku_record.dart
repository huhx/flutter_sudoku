import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/model/sudoku_input.dart';

import 'sudoku.dart';

class SudokuRecord extends Equatable {
  final int? id;
  final int year;
  final int month;
  final int day;
  final Difficulty difficulty;
  final GameStatus gameStatus;
  final LogStatus logStatus;
  final List<SudokuInput> sudokuInputs;
  final int duration;
  final int errorCount;
  final int tipCount;
  final int startTime;
  final int endTime;
  final int createTime;

  @override
  List<Object?> get props => [
        id,
        year,
        month,
        day,
        difficulty,
        gameStatus,
        logStatus,
        sudokuInputs,
        duration,
        errorCount,
        tipCount,
        startTime,
        endTime,
        createTime
      ];

  const SudokuRecord({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.difficulty,
    required this.gameStatus,
    required this.logStatus,
    required this.sudokuInputs,
    required this.duration,
    required this.errorCount,
    required this.tipCount,
    required this.startTime,
    required this.endTime,
    required this.createTime,
  });

  String get dateString {
    return DateTime(year, month, day).toDateString();
  }

  String get startString {
    return DateTime.fromMillisecondsSinceEpoch(startTime).toDateTimeString;
  }

  String get endString {
    return DateTime.fromMillisecondsSinceEpoch(endTime).toDateTimeString;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'difficulty': difficulty.level,
      'gameStatus': gameStatus.name,
      'logStatus': logStatus.name,
      'sudokuInputs': sudokuInputs,
      'duration': duration,
      'errorCount': errorCount,
      'tipCount': tipCount,
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
      gameStatus: GameStatus.values.byName(json['gameStatus'] as String),
      logStatus: LogStatus.values.byName(json['logStatus'] as String),
      sudokuInputs:
          (json['sudokuInputs'] as List<dynamic>).map((e) => SudokuInput.fromJson(e as Map<String, dynamic>)).toList(),
      duration: json['duration'] as int,
      errorCount: json['errorCount'] as int,
      tipCount: json['tipCount'] as int,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      createTime: json['createTime'] as int,
    );
  }
}

enum LogStatus { normal, delete }
