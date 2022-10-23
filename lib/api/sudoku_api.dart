import 'package:dio/dio.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/dio_util.dart';

class SudokuApi {
  Future<SudokuInfo> getSudokuData(DateTime dateTime, Difficulty difficulty) async {
    const String url = "sudokuUrl";
    final SudokuRequest request = SudokuRequest(dateTime: dateTime.toDate, difficulty: difficulty);
    final Response response = await RestClient.getInstance().get(url, queryParameters: request.toRequest());

    return SudokuResponse.fromJson(response.data).toSudoku();
  }
}

final sudokuApi = SudokuApi();
