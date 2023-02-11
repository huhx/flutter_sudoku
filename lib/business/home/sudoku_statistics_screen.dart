import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';

class SudokuStatisticsScreen extends StatelessWidget {
  const SudokuStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("统计"),
      ),
      body: const Text("sudoku screen"),
    );
  }
}
