import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';

class SudokuSettingScreen extends StatelessWidget {
  const SudokuSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("设置"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text("Setting"),
      ),
    );
  }
}
