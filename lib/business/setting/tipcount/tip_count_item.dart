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
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text('提醒次数', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Flexible(
        child: TextFormField(
          initialValue: "$tipCount",
          textAlign: TextAlign.end,
          autofocus: false,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            fillColor: Colors.transparent,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            isCollapsed: true,
          ),
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
