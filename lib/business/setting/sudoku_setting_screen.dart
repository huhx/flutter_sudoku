import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';

import 'cache/clear_cache_item.dart';
import 'dark/dark_item.dart';
import 'sound/play_sound_item.dart';

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
          ],
        ),
      ),
    );
  }
}
