import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/theme/theme.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuScreen extends StatefulWidget {
  final SudokuRequest request;

  const SudokuScreen(this.request, {super.key});

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
      body: FutureBuilder(
        future: sudokuApi.getSudokuData(widget.request),
        builder: (context, snap) {
          if (!snap.hasData) return const CenterProgressIndicator();
          final SudokuResponse sudoku = snap.data as SudokuResponse;
          final List<List<int>> questions = sudoku.fromQuestion();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
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
                ),
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: List.generate(
                    9,
                    (row) => TableRow(
                      children: List.generate(9, (column) => SudokuItem(row, column, questions[row][column])),
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
          );
        },
      ),
    );
  }
}

class SudokuItem extends StatelessWidget {
  final int row;
  final int column;
  final int number;

  const SudokuItem(this.row, this.column, this.number, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        child: Text(number == 0 ? "" : number.toString()),
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
