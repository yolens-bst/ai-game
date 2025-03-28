import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _enabled = true;
  double _volume = 0.7;

  Future<void> init() async {
    // Preload sounds
    await _bgmPlayer.setAsset('assets/sounds/bgm.mp3');
    await _bgmPlayer.setAsset('assets/sounds/home-bgm.mp3');
    await _sfxPlayer.setAsset('assets/sounds/correct.mp3');
    await _sfxPlayer.setAsset('assets/sounds/wrong.mp3');
    await _sfxPlayer.setAsset('assets/sounds/combo.mp3');
    await _sfxPlayer.setAsset('assets/sounds/start.mp3');
    await _sfxPlayer.setAsset('assets/sounds/end.mp3');
    await _sfxPlayer.setAsset('assets/sounds/defeat.mp3');
    await _sfxPlayer.setAsset('assets/sounds/victory.mp3');
    await _sfxPlayer.setAsset('assets/sounds/click.mp3');
  }

  Future<void> playClick() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setVolume(0.8);
      await _sfxPlayer.setAsset('assets/sounds/click.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing click sound: $e');
    }
  }

  Future<void> playCorrect() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/correct.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing tap success sound: $e');
    }
  }

  Future<void> playWrong() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/wrong.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing tap error sound: $e');
    }
  }

  Future<void> playCombo(int count) async {
    if (!_enabled) return;
    try {
      final pitch = 1.0 + (count.clamp(0, 10) * 0.05);
      await _sfxPlayer.setSpeed(pitch);
      await _sfxPlayer.setAsset('assets/sounds/combo.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing combo sound: $e');
    }
  }

  Future<void> playStart() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/start.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing start sound: $e');
    }
  }

  Future<void> playEnd() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/end.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing end sound: $e');
    }
  }

  Future<void> playDefeat() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/defeat.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing defeat sound: $e');
    }
  }

  Future<void> playVictory() async {
    if (!_enabled) return;
    try {
      await _sfxPlayer.setAsset('assets/sounds/victory.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      print('Error playing victory sound: $e');
    }
  }

  Future<void> playBgm({bool isHome = false}) async {
    if (!_enabled) return;
    await _bgmPlayer.setLoopMode(LoopMode.one);
    try {
      await _bgmPlayer.setVolume(0);
      await _bgmPlayer.setAsset(
        isHome ? 'assets/sounds/home-bgm.mp3' : 'assets/sounds/bgm.mp3',
      );
      await _bgmPlayer.play();
      await _fadeIn(duration: 1.0);
    } catch (e) {
      print('Error playing BGM: $e');
    }
  }

  Future<void> stopBgm() async {
    // await _fadeOut();
    await _bgmPlayer.setLoopMode(LoopMode.off);
    await _bgmPlayer.stop();
  }

  Future<void> _fadeIn({double duration = 3.0}) async {
    const steps = 30;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: (duration * 1000 ~/ steps)));
      await _bgmPlayer.setVolume(_volume * i / steps);
    }
  }

  Future<void> _fadeOut({double duration = 2.0}) async {
    const steps = 20;
    final currentVolume = _volume;
    for (int i = steps; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: (duration * 1000 ~/ steps)));
      await _bgmPlayer.setVolume(currentVolume * i / steps);
    }
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
    if (!enabled) {
      _bgmPlayer.stop();
    } else {
      playBgm();
    }
  }
}
