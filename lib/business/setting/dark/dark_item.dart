import 'package:flutter/material.dart';
import 'package:flutter_sudoku/provider/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DarkItem extends HookConsumerWidget {
  const DarkItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('夜间模式', style: TextStyle(fontSize: 14)),
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (isDark) => ref.read(themeProvider.notifier).setDark(isDark),
          )
        ],
      ),
    );
  }
}
