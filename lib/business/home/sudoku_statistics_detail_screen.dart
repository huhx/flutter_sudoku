import 'package:flutter/material.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

class SudokuStatisticsDetailScreen extends StatelessWidget {
  final Difficulty difficulty;

  const SudokuStatisticsDetailScreen(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
      children: const [
        ListTile(
          title: Text("已完成游戏"),
          trailing: Text("12"),
        ),
        ListTile(
          title: Text("最佳时间"),
          trailing: Text("02:04"),
        ),
        ListTile(
          title: Text("平均时间"),
          trailing: Text("02:04"),
        ),
        ListTile(
          title: Text("最长连赢"),
          trailing: Text("12"),
        ),
        ListTile(
          title: Text("最惨连败"),
          trailing: Text("12"),
        ),
      ],
    );
  }
}
