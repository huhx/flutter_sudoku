import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sudoku/provider/tip_count_provider.dart';
import 'package:flutter_sudoku/theme/shape.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipCountItem extends HookConsumerWidget {
  const TipCountItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipCount = ref.watch(tipCountProvider);
    final userTextController = useTextEditingController()
      ..text = tipCount.toString()
      ..selection = TextSelection.fromPosition(const TextPosition(offset: 1));

    return CupertinoListTile(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('提醒次数', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Flexible(
        child: TextFormField(
          controller: userTextController,
          onTap: () => userTextController.selection = TextSelection.fromPosition(const TextPosition(offset: 1)),
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          decoration: inputDecoration,
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          onChanged: (String value) {
            if (value.isNotEmpty) {
              ref.read(tipCountProvider.notifier).set(int.parse(value));
            }
          },
        ),
      ),
    );
  }
}
