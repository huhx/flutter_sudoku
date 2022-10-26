import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSucess() async {
    if (PrefsUtil.isPlaySound()) {
      await playSound('success.mp3');
    }
  }

  Future<void> playInput() async {
    if (PrefsUtil.isPlaySound()) {
      await playSound('input.mp3');
    }
  }

  Future<void> playFail() async {
    if (PrefsUtil.isPlaySound()) {
      await playSound('fail.mp3');
    }
  }

  Future<void> playSound(String assetName) async {
    await _player.setAsset('assets/sound/$assetName');
    await _player.play();
  }

  Future<void> playVoice(String soundUrl) async {
    await _player.setUrl(soundUrl);
    await _player.play();
  }
}

final AudioService audioService = AudioService();
