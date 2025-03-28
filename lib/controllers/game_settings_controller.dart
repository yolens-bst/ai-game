import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  }

  Future<void> init() async {
    final storage = GetStorage();
    if (storage.hasData('game_settings')) {
      _settings.value = GameSettings.fromJson(storage.read('game_settings'));
    }
    return;
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
    await GetStorage().write('game_settings', _settings.value.toJson());
  }
}
