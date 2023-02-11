import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/profile/onboard_screen.dart';
import 'package:flutter_sudoku/business/record/sudoku_record_list_screen.dart';
import 'package:flutter_sudoku/business/setting/sudoku_about_screen.dart';
import 'package:flutter_sudoku/business/setting/sudoku_setting_screen.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SudokuDrawer extends StatelessWidget {
  const SudokuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "每日数独",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const SvgIcon(name: "item_onboarding"),
            title: Text("玩法介绍", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.pop();
              context.goto(const OnboardScreen());
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "item_ analyze"),
            title: Text("统计", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              CommUtil.toBeDev();
              context.pop();
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "item_record"),
            title: Text("记录", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.pop();
              context.goto(const SudokuRecordListScreen());
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "sudoku_share"),
            title: Text("分享", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.pop();
              context.share(title: '分享一款非常棒的数独游戏, 休闲益智.', subject: "sudoku");
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "item_about"),
            title: Text("关于", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.pop();
              context.goto(const SudokuAboutScreen());
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "item_feedback"),
            title: Text("意见反馈", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () async {
              context.pop();
              final Uri mail = Uri(
                scheme: 'mailto',
                path: 'gohuhx@gmail.com',
                query: 'subject=[数独]意见反馈&body=意见反馈:',
              );
              if (await canLaunchUrl(mail)) {
                await launchUrl(mail);
              } else {
                Fluttertoast.showToast(msg: 'Can not open email app.');
              }
            },
          ),
          ListTile(
            leading: const SvgIcon(name: "sudoku_setting"),
            title: Text("设置", style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              context.pop();
              context.goto(const SudokuSettingScreen());
            },
          ),
        ],
      ),
    );
  }
}
