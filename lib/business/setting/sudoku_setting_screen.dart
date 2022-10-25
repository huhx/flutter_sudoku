import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';

import 'cache/clear_cache_item.dart';

class SudokuSettingScreen extends StatelessWidget {
  const SudokuSettingScreen({Key? key}) : super(key: key);

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
          ],
        ),
      ),
    );
  }
}
