import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/theme/theme.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuOperate extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuOperate(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OperateItem(
            icon: SvgIcon(name: "operate_clear", color: sudokuNotifier.canClear ? themeColor : Colors.grey),
            label: "擦除",
            onPressed: sudokuNotifier.canClear ? () => sudokuNotifier.clear() : null,
          ),
          OperateItem(
            icon: Badge(
              padding: const EdgeInsets.all(3),
              badgeContent: sudokuNotifier.enableNotes
                  ? const Text("on", style: TextStyle(fontSize: 8))
                  : const Text("off", style: TextStyle(fontSize: 8)),
              child: const SvgIcon(name: "operate_note", color: themeColor),
            ),
            label: "笔记",
            onPressed: () => sudokuNotifier.toggleNote(),
          ),
          OperateItem(
            icon: Badge(
              padding: const EdgeInsets.all(3),
              badgeColor: sudokuNotifier.canUseTip ? Colors.red : Colors.grey,
              badgeContent: Text("${sudokuNotifier.tipCount}", style: const TextStyle(fontSize: 8)),
              child: SvgIcon(name: "operate_tip", color: sudokuNotifier.canUseTip ? themeColor : Colors.grey),
            ),
            label: "提示",
            onPressed: sudokuNotifier.canUseTip ? () => useTip(sudokuNotifier) : null,
          ),
        ],
      ),
    );
  }

  void useTip(SudokuNotifier sudokuNotifier) {
    if (sudokuNotifier.tipCount <= 0) {
      CommUtil.toast(message: "您的提示次数已经用完");
      return;
    }
    sudokuNotifier.useTip();
  }
}

class OperateItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const OperateItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          icon,
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
