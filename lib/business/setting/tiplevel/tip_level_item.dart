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
    final provider = ref.watch(tipLevelProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () async {
          final TipLevel? result = await context.goto(TipLevelSettingScreen(tipLevel: provider.tipLevel));
          if (result != null) {
            provider.setTipLevel(result);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('智能等级', style: TextStyle(fontSize: 14)),
            Text(
              provider.tipLevel.description,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
