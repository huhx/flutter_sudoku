import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/parser/sudoku_parser.dart';
import 'package:flutter_sudoku/util/dio_util.dart';

class SudokuApi {
  Future<SudokuResponse> getSudokuData(SudokuRequest request) async {
    const String url = "https://cn.sudokupuzzle.org/online2.php";
    final Response response = await RestClient.getInstance().get(url, queryParameters: request.toJson());

    return compute(SudokuParser.parse, response.data as String);
  }
}

final sudokuApi = SudokuApi();
