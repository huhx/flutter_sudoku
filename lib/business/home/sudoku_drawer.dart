import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/profile/onboard_screen.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuDrawer extends StatelessWidget {
  const SudokuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "每日数独",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const SvgIcon(name: "main_category"),
            title: const Text("玩法介绍"),
            onTap: () {
              context.pop();
              context.goto(const OnboardScreen());
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
