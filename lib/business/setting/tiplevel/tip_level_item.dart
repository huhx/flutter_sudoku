import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/setting/tiplevel/tip_level_setting_screen.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:flutter_sudoku/provider/tip_level_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipLevelItem extends HookConsumerWidget {
  const TipLevelItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipLevel = ref.watch(tipLevelProvider);

    return CupertinoListTile(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text('智能等级', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Text(tipLevel.description),
      onTap: () async {
        final TipLevel? result = await context.goto(TipLevelSettingScreen(tipLevel: tipLevel));
        if (result != null) {
          ref.read(tipLevelProvider.notifier).set(result);
        }
      },
    );
  }
}
