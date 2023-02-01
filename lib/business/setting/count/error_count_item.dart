import 'package:flutter/material.dart';
import 'package:flutter_sudoku/provider/error_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorCountItem extends HookConsumerWidget {
  const ErrorCountItem({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorCount = ref.watch(errorCountProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('错误次数', style: TextStyle(fontSize: 14)),
          Flexible(
            child: TextFormField(
              initialValue: "$errorCount",
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
