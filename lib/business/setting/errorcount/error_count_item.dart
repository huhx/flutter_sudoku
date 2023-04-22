import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sudoku/provider/error_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorCountItem extends HookConsumerWidget {
  const ErrorCountItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorCount = ref.watch(errorCountProvider);
    final userTextController = useTextEditingController()
      ..text = errorCount.toString()
      ..selection = TextSelection.fromPosition(const TextPosition(offset: 1));

    return CupertinoListTile(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text('错误次数', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Flexible(
        child: TextFormField(
          controller: userTextController,
          onTap: () => userTextController.selection = TextSelection.fromPosition(const TextPosition(offset: 1)),
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.end,
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
              ref.read(errorCountProvider.notifier).set(int.parse(value));
            }
          },
        ),
      ),
    );
  }
}
