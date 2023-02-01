import 'package:dio/dio.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/common/env.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/dio_util.dart';

class SudokuApi {
  Future<SudokuResponse> getSudokuData(DateTime dateTime, Difficulty difficulty) async {
    final SudokuRequest request = SudokuRequest(dateTime: dateTime.toDate, difficulty: difficulty);
    final Response response = await RestClient.instance.get(Env.sudokuUrl, queryParameters: request.toRequest());

    return SudokuResponse.fromJson(response.data);
  }
}

final SudokuApi sudokuApi = SudokuApi();
