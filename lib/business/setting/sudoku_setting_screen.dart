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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: ListView(
          children: const [
            ClearCacheItem(),
            Divider(),
            PlaySoundItem(),
            Divider(),
            DarkItem(),
            Divider(),
            TipLevelItem(),
            Divider(),
            ErrorCountItem(),
            Divider(),
            TipCountItem(),
          ],
        ),
      ),
    );
  }
}
