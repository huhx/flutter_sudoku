import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/provider/tip_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipCountItem extends HookConsumerWidget {
  const TipCountItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipCount = ref.watch(tipCountProvider);

    return CupertinoListTile(
      title: Text('提醒次数', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Flexible(
        child: TextFormField(
          initialValue: "$tipCount",
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium,
          autofocus: false,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: InputBorder.none),
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
