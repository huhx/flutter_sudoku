import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaySoundItem extends HookConsumerWidget {
  const PlaySoundItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaySound = useState(PrefsUtil.isPlaySound());

    return CupertinoListTile(
      title: Text('音效', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Switch(
        value: isPlaySound.value,
        onChanged: (isPlay) {
          isPlaySound.value = isPlay;
          PrefsUtil.enablePlaySound(isPlay);
        },
      ),
    );
  }
}
