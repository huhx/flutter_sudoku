import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

import 'sudoku_drawer.dart';
import 'sudoku_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("数独"),
        actions: [
          IconButton(
            icon: const SvgIcon(name: "more_hor", color: Colors.white, size: 20),
            onPressed: () => CommUtil.toBeDev(),
          )
        ],
      ),
      drawer: const SudokuDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final Difficulty? difficulty = await showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text("游戏难度"),
                      children: Difficulty.values
                          .map((e) => SimpleDialogOption(
                              onPressed: () => context.pop(e), child: Padding(padding: const EdgeInsets.only(top: 8), child: Text(e.label))))
                          .toList(),
                    );
                  },
                );
                if (difficulty != null) {
                  context.goto(SudokuScreen(dateTime, difficulty));
                }
              },
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
