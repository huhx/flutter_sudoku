import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';

import 'cache/clear_cache_item.dart';
import 'dark/dark_item.dart';
import 'errorcount/error_count_item.dart';
import 'sound/play_sound_item.dart';
import 'tipcount/tip_count_item.dart';
import 'tiplevel/tip_level_item.dart';

class SudokuSettingScreen extends StatelessWidget {
  const SudokuSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("设置"),
      ),
      body: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 8,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
            children: const [
              ClearCacheItem(),
              PlaySoundItem(),
              DarkItem(),
              TipLevelItem(),
            ],
          ),
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 8,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
            children: const [
              ErrorCountItem(),
              TipCountItem(),
            ],
          ),
        ],
      ),
    );
  }
}
