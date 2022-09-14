import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

import 'sudoku_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("数独")),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.goto(const SudokuScreen()),
              icon: const SvgIcon(name: "home_double_right", color: Colors.white),
              label: const Text("新游戏"),
            ),
            ElevatedButton.icon(
              onPressed: () => CommUtil.toBeDev(),
              icon: const SvgIcon(name: "home_double_right", color: Colors.white),
              label: const Text("继续游戏"),
            )
          ],
        ),
      ),
    );
  }
}
