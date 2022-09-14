import 'package:flutter_sudoku/common/string_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

class SudokuParser {
  static SudokuResponse parse(String string) {
    final RegExp regExp = RegExp("tmda='([0-9]+)';");
    final String result = regExp.firstMatch(string)!.group(1)!;
    final int level = result.substring(162, 163).toInt();

    return SudokuResponse(
      question: result.substring(0, 81),
      answer: result.substring(81, 162),
      difficulty: Difficulty.from(level - 1),
    );
  }
}
