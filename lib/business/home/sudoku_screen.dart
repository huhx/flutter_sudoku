import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/theme/theme.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("中级"),
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
            ),
            Table(
              border: TableBorder.all(color: Colors.grey),
              children: List.generate(
                9,
                (row) => TableRow(
                  children: List.generate(9, (column) => SudokuItem(row, column)),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.red),
                  ),
                ),
              ),
            ),
            Padding(
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
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 9,
              crossAxisSpacing: 4,
              children: List.generate(
                9,
                (index) => NumberItem(index + 1, (int num) => CommUtil.toast(message: "click $num")),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SudokuItem extends StatelessWidget {
  final int row;
  final int column;

  const SudokuItem(this.row, this.column, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: Text(row.toString()),
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
