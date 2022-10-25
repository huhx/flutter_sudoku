import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku_input.dart';

import 'sudoku.dart';

class SudokuInputLog extends Equatable {
  final String question;
  final String answer;
  final Difficulty difficulty;
  final int dateTime;
  final GameStatus gameStatus;
  final List<SudokuInput> sudokuInputs;

  const SudokuInputLog({
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.dateTime,
    required this.gameStatus,
    required this.sudokuInputs,
  });

  int get totalSteps => sudokuInputs.length;

  int get inputSteps {
    return sudokuInputs.where((sudokuInput) => sudokuInput.value != 0).length;
  }

  int get noteSteps {
    return sudokuInputs.where((sudokuInput) => sudokuInput.noteValues.isNotEmpty).length;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'question': question,
      'answer': answer,
      'difficulty': difficulty.level,
      'gameStatus': gameStatus.name,
      'dateTime': dateTime,
      'sudokuInputs': jsonEncode(sudokuInputs.map((e) => e.toJson()).toList())
    };
  }

  factory SudokuInputLog.fromJson(Map<String, dynamic> json) {
    return SudokuInputLog(
      question: json['question'] as String,
      answer: json['answer'] as String,
      difficulty: Difficulty.from(json['difficulty'] as int),
      gameStatus: GameStatus.values.byName(json['gameStatus'] as String),
      dateTime: json['dateTime'] as int,
      sudokuInputs: (jsonDecode(json['sudokuInputs']) as List<dynamic>)
          .map((e) => SudokuInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [question, answer, difficulty, dateTime, sudokuInputs];
}
