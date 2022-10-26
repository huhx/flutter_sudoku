import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaySoundItem extends HookConsumerWidget {
  const PlaySoundItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaySound = useState(PrefsUtil.isPlaySound());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('音效', style: TextStyle(fontSize: 14)),
          Switch(
            value: isPlaySound.value,
            onChanged: (isPlay) {
              isPlaySound.value = isPlay;
              PrefsUtil.enablePlaySound(isPlay);
            },
          )
        ],
      ),
    );
  }
}
