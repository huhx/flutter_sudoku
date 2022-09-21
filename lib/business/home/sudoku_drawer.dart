import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuDrawer extends StatelessWidget {
  const SudokuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Header"),
          ),
          ListTile(
            leading: const SvgIcon(name: "main_category"),
            title: const Text("玩法介绍"),
            onTap: () {
              CommUtil.toBeDev();
              context.pop();
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "main_category"),
            title: const Text("统计"),
            onTap: () {
              CommUtil.toBeDev();
              context.pop();
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "main_category"),
            title: const Text("设置"),
            onTap: () {
              CommUtil.toBeDev();
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
