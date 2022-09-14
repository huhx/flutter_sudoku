import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/parser/sudoku_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should return two-dimension array data when parse", () {
    const String string = '''
    function newClick() {
        var tmda;
        tmda='800070000003809000054000060060057100008301005000000000000023900000700050600000701896475312123869574754132869369257148278341695541698237417523986982716453635984721219996';
        document.getElementById('tm').value = tmda.substring(0, 81);
        document.getElementById('da').value = tmda.substring(81, 162);
        document.getElementById('nd').value = tmda.substring(162, 163);
        document.getElementById('tmxh').value = tmda.substring(163, 170);
        drawsudoku();
        drawcookie();
    }
    ''';

    final SudokuResponse result = SudokuParser.parse(string);

    expect(
      result,
      const SudokuResponse(
        question: "800070000003809000054000060060057100008301005000000000000023900000700050600000701",
        answer: "896475312123869574754132869369257148278341695541698237417523986982716453635984721",
        difficulty: Difficulty.c,
      ),
    );
  });
}
