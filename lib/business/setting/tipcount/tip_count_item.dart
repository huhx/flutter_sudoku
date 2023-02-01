import 'package:flutter/material.dart';
import 'package:flutter_sudoku/provider/error_count_provider.dart';
import 'package:flutter_sudoku/provider/tip_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipCountItem extends HookConsumerWidget {
  const TipCountItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipCount = ref.watch(tipCountProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('提醒次数', style: TextStyle(fontSize: 14)),
          Flexible(
            child: TextFormField(
              initialValue: "$tipCount",
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  ref.read(errorCountProvider.notifier).set(int.parse(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
