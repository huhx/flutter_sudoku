import 'package:dio/dio.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/dio_util.dart';

class SudokuApi {
  Future<SudokuResponse> getSudokuData(DateTime dateTime, Difficulty difficulty) async {
    const String url = "sudokuUrl";
    final SudokuRequest request = SudokuRequest.from(dateTime, difficulty);
    final Response response = await RestClient.getInstance().get(url, queryParameters: request.toJson());

    return SudokuResponse.fromJson(response.data);
  }
}

final sudokuApi = SudokuApi();
