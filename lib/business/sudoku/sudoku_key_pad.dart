import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuKeyPad extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuKeyPad(this.sudokuNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 9,
      crossAxisSpacing: 10,
      children: List.generate(
        9,
        (index) => NumberItem(index + 1, (int num) {
          final GameStatus gameStatus = sudokuNotifier.onInput(num);
          if (gameStatus == GameStatus.success) {
            CommUtil.toast(message: "恭喜你成功过关");
          } else if(gameStatus == GameStatus.failed) {
            CommUtil.toast(message: "已达到最大错误次数，游戏失败");
          }
        }),
      ),
    );
  }
}

class NumberItem extends StatelessWidget {
  final int number;
  final Function(int) onPressed;

  const NumberItem(this.number, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(number),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
