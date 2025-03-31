import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickle_game/game/character_renderer.dart';
import 'dart:convert';
import '../models/game_settings.dart';

class GameSettingsController extends GetxController {
  final Rx<GameSettings> _settings = GameSettings().obs;
  late final RxBool _soundEnabled;

  GameSettings get settings => _settings.value;
  RxBool get soundEnabled => _soundEnabled;

  GameSettingsController() {
    _soundEnabled = _settings.value.soundEnabled.obs;
    _settings.listen((settings) {
      _soundEnabled.value = settings.soundEnabled;
    });
    ever(_settings, (GameSettings settings) async {
      await saveSettings();
    });
    init();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('game_settings');
    print((jsonString));
    if (jsonString != null) {
      try {
        _settings.value = GameSettings.fromJson(json.decode(jsonString));
      } catch (e) {
        print('Error parsing game settings: $e');
      }
    }
  }

  void toggleSound() {
    _settings.update((val) {
      val?.soundEnabled = !val.soundEnabled;
    });
  }

  void setDifficulty(DifficultyLevel level) {
    _settings.update((val) {
      val?.difficulty = level;
    });
  }

  void setDuration(double duration) {
    _settings.update((val) {
      val?.duration = duration;
    });
  }

  void setFaceMode(FaceDirection faceMode) {
    _settings.update((val) {
      val?.faceMode = faceMode;
    });
  }

  void setEnableSwing(bool value) {
    _settings.update((val) {
      val?.enableSwing = value;
    });
  }

  void setEnableHints(bool value) {
    _settings.update((val) {
      val?.enableHints = value;
    });
  }

  void setVibrationEnabled(bool value) {
    _settings.update((val) {
      val?.vibrationEnabled = value;
    });
  }

  void setPlayerName(String name) {
    _settings.update((val) {
      val?.playerName = name;
    });
  }

  void setLanguage(String language) {
    _settings.update((val) {
      val?.language = language;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    print('save' + (_settings.value.toJson()).toString());
    await prefs.setString(
      'game_settings',
      json.encode(_settings.value.toJson()),
    );
  }
}
