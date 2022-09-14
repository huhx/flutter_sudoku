import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("数独"),
        leading: const AppbarBackButton(),
        actions: [
          SvgActionIcon(
            name: "sudoku_color",
            onTap: () => CommUtil.toBeDev(),
          ),
          SvgActionIcon(
            name: "sudoku_setting",
            onTap: () => CommUtil.toBeDev(),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text("Sudoku Screen"),
      ),
    );
  }
}
