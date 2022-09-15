import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const SudokuResponse response = SudokuResponse(
    question: "800070000003809000054000060060057100008301005000000000000023900000700050600000701",
    answer: "896475312123869574754132869369257148278341695541698237417523986982716453635984721",
    difficulty: Difficulty.c,
  );

  test("should return question arrays when invoke fromQuestion", () {
    final List<List<int>> result = response.fromQuestion();

    expect(result, [
      [8, 0, 0, 0, 7, 0, 0, 0, 0],
      [0, 0, 3, 8, 0, 9, 0, 0, 0],
      [0, 5, 4, 0, 0, 0, 0, 6, 0],
      [0, 6, 0, 0, 5, 7, 1, 0, 0],
      [0, 0, 8, 3, 0, 1, 0, 0, 5],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 2, 3, 9, 0, 0],
      [0, 0, 0, 7, 0, 0, 0, 5, 0],
      [6, 0, 0, 0, 0, 0, 7, 0, 1]
    ]);
  });

  test("should return answer arrays when invoke fromAnswer", () {
    final List<List<int>> result = response.fromAnswer();

    expect(result, [
      [8, 9, 6, 4, 7, 5, 3, 1, 2],
      [1, 2, 3, 8, 6, 9, 5, 7, 4],
      [7, 5, 4, 1, 3, 2, 8, 6, 9],
      [3, 6, 9, 2, 5, 7, 1, 4, 8],
      [2, 7, 8, 3, 4, 1, 6, 9, 5],
      [5, 4, 1, 6, 9, 8, 2, 3, 7],
      [4, 1, 7, 5, 2, 3, 9, 8, 6],
      [9, 8, 2, 7, 1, 6, 4, 5, 3],
      [6, 3, 5, 9, 8, 4, 7, 2, 1]
    ]);
  });

  test("should return empty check list when invoke check given user not answer", () {
    final List<List<int>> userAnswer = [
      [8, 0, 0, 0, 7, 0, 0, 0, 0],
      [0, 0, 3, 8, 0, 9, 0, 0, 0],
      [0, 5, 4, 0, 0, 0, 0, 6, 0],
      [0, 6, 0, 0, 5, 7, 1, 0, 0],
      [0, 0, 8, 3, 0, 1, 0, 0, 5],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 2, 3, 9, 0, 0],
      [0, 0, 0, 7, 0, 0, 0, 5, 0],
      [6, 0, 0, 0, 0, 0, 7, 0, 1]
    ];

    final List<SudokuCheck> result = response.check(userAnswer);

    expect(result, []);
  });

  test("should return failed check list when invoke check given user answer not correct", () {
    final List<List<int>> userAnswer = [
      [8, 4, 6, 4, 7, 0, 0, 0, 0],
      [0, 9, 3, 8, 0, 9, 0, 0, 0],
      [0, 5, 4, 0, 0, 0, 0, 6, 0],
      [0, 6, 0, 0, 5, 7, 1, 0, 0],
      [0, 0, 8, 3, 0, 1, 7, 0, 5],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 2, 3, 9, 0, 0],
      [0, 0, 0, 7, 0, 0, 0, 5, 0],
      [6, 0, 0, 0, 0, 0, 7, 0, 1]
    ];

    final List<SudokuCheck> result = response.check(userAnswer);

    expect(result.length, 3);
    expect(result[0], const SudokuCheck(x: 0, y: 1, actual: 4, expect: 9));
    expect(result[1], const SudokuCheck(x: 1, y: 1, actual: 9, expect: 2));
    expect(result[2], const SudokuCheck(x: 4, y: 6, actual: 7, expect: 6));
  });
}