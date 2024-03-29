import 'dart:convert';

import 'package:app_common_flutter/extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'sudoku.dart';
import 'sudoku_input_log.dart';

class SudokuRecord extends Equatable {
  final int? id;
  final int year;
  final int month;
  final int day;
  final Difficulty difficulty;
  final GameStatus gameStatus;
  final LogStatus logStatus;
  final SudokuInputLog sudokuInputLog;
  final int duration;
  final int errorCount;
  final int tipCount;
  final int startTime;
  final int endTime;
  final int createTime;

  const SudokuRecord({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.difficulty,
    required this.gameStatus,
    required this.logStatus,
    required this.sudokuInputLog,
    required this.duration,
    required this.errorCount,
    required this.tipCount,
    required this.startTime,
    required this.endTime,
    required this.createTime,
  });

  String get shareTitle {
    return "huhx://sudoku?dateTime=$dateString&difficulty=${difficulty.level}";
  }

  String get dateString {
    return DateTime(year, month, day).dateString;
  }

  String get createTimeString {
    return createTime.dateString;
  }

  String get startString {
    return DateTime.fromMillisecondsSinceEpoch(startTime).dateTimeString;
  }

  String get endString {
    return DateTime.fromMillisecondsSinceEpoch(endTime).dateTimeString;
  }

  Color get color {
    if (duration > 15 * 60) {
      return Colors.red;
    } else if (duration > 5 * 60) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  bool get isSuccess {
    return gameStatus == GameStatus.success;
  }

  bool get isFailed {
    return gameStatus == GameStatus.failed;
  }

  String get secondsString => duration.timeString;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'difficulty': difficulty.level,
      'gameStatus': gameStatus.name,
      'logStatus': logStatus.name,
      'sudokuInputLog': jsonEncode(sudokuInputLog.toJson()),
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
      sudokuInputLog: SudokuInputLog.fromJson(jsonDecode(json['sudokuInputLog']) as Map<String, dynamic>),
      duration: json['duration'] as int,
      errorCount: json['errorCount'] as int,
      tipCount: json['tipCount'] as int,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      createTime: json['createTime'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        year,
        month,
        day,
        difficulty,
        gameStatus,
        logStatus,
        sudokuInputLog,
        duration,
        errorCount,
        tipCount,
        startTime,
        endTime,
        createTime,
      ];
}

enum LogStatus { normal, delete }
