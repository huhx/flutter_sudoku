import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/theme/theme.dart';

class SudokuOperate extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuOperate(this.sudokuNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          OperateItem(iconName: "operate_undo", label: "撤销"),
          OperateItem(iconName: "operate_clear", label: "擦除"),
          OperateItem(iconName: "operate_note", label: "笔记"),
          OperateItem(iconName: "operate_quick_note", label: "一键笔记"),
          OperateItem(iconName: "operate_tip", label: "提示"),
        ],
      ),
    );
  }
}

class OperateItem extends StatelessWidget {
  final String iconName;
  final String label;

  const OperateItem({
    super.key,
    required this.iconName,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgIcon(name: iconName, color: themeColor),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
