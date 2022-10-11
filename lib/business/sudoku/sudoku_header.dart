import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuHeader extends StatelessWidget {
  final SudokuResponse sudoku;

  const SudokuHeader(this.sudoku, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(sudoku.difficulty.label),
        const Text("错误：1/3", style: TextStyle(color: Colors.red)),
        Row(
          children: [
            IconButton(
              onPressed: () => CommUtil.toBeDev(),
              icon: const SvgIcon(name: "sudoku_stop"),
            ),
            const Text("01:20"),
          ],
        )
      ],
    );
  }
}
