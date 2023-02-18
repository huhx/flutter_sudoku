import 'package:app_common_flutter/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipLevelSettingScreen extends HookConsumerWidget {
  final TipLevel tipLevel;

  const TipLevelSettingScreen({required this.tipLevel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipLevelState = useState(tipLevel);

    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("智能等级设置"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, tipLevelState.value),
            child: const Text("完成", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        physics: const ListScrollPhysics(),
        children: TipLevel.values.map((tipLevel) {
          return TipLevelItem(
            isChecked: tipLevelState.value == tipLevel,
            tipLevel: tipLevel,
            label: tipLevel.description,
            callback: () => tipLevelState.value = tipLevel,
          );
        }).toList(),
      ),
    );
  }
}

class TipLevelItem extends StatelessWidget {
  final bool isChecked;
  final TipLevel tipLevel;
  final String label;
  final VoidCallback callback;

  const TipLevelItem({
    super.key,
    required this.isChecked,
    required this.tipLevel,
    required this.label,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Opacity(
              opacity: isChecked ? 1 : 0,
              child: const SvgIcon(name: "level_check"),
            ),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
