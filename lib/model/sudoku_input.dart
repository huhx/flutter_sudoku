import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';

class SudokuInput extends Equatable {
  final Point point;
  final int value;
  final bool isCorrect;
  final bool useTip;
  final List<int> noteValues;

  const SudokuInput({
    required this.point,
    required this.value,
    required this.isCorrect,
    required this.useTip,
    required this.noteValues,
  });

  factory SudokuInput.clear(Point point) {
    return SudokuInput(
      point: point,
      value: 0,
      isCorrect: false,
      useTip: false,
      noteValues: const [],
    );
  }

  factory SudokuInput.note(Point point, List<int> noteValue) {
    return SudokuInput(
      point: point,
      value: 0,
      isCorrect: false,
      useTip: false,
      noteValues: noteValue,
    );
  }

  factory SudokuInput.tip(Point point, int value) {
    return SudokuInput(
      point: point,
      value: value,
      isCorrect: true,
      useTip: true,
      noteValues: const [],
    );
  }

  factory SudokuInput.normal(Point point, bool isCorrect, int value) {
    return SudokuInput(
      point: point,
      value: value,
      isCorrect: isCorrect,
      useTip: false,
      noteValues: const [],
    );
  }

  factory SudokuInput.fromJson(Map<String, dynamic> json) {
    return SudokuInput(
      point: Point.fromJson(jsonDecode(json['point']) as Map<String, dynamic>),
      value: json['value'] as int,
      isCorrect: json['isCorrect'] as bool,
      useTip: json['useTip'] as bool,
      noteValues: (json['noteValues'] as List<dynamic>).map((noteValue) => noteValue as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'point': jsonEncode(point.toJson()),
      'value': value,
      'isCorrect': isCorrect,
      'useTip': useTip,
      'noteValues': noteValues,
    };
  }

  @override
  List<Object?> get props => [point, value, isCorrect, useTip, noteValues];
}
