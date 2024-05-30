import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/provider/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DarkItem extends HookConsumerWidget {
  const DarkItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return CupertinoListTile(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('夜间模式', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Switch.adaptive(
        value: themeMode == ThemeMode.dark,
        onChanged: (isDark) => ref.read(themeProvider.notifier).setDark(isDark),
      ),
    );
  }
}
