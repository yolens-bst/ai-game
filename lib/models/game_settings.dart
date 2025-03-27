import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  static final GameSettings _instance = GameSettings._internal();
  factory GameSettings() => _instance;
  GameSettings._internal();

  late SharedPreferences _prefs;

  int _difficulty = 1;
  String _duration = '30秒';
  bool _enableSwing = true;
  bool _enableHints = false;
  bool _soundEnabled = false;

  int get difficulty => _difficulty;
  String get duration => _duration;
  bool get enableSwing => _enableSwing;
  bool get enableHints => _enableHints;
  bool get soundEnabled => _soundEnabled;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _difficulty = _prefs.getInt('difficulty') ?? 1;
    _duration = _prefs.getString('duration') ?? '30秒';
    _enableSwing = _prefs.getBool('enableSwing') ?? true;
    _enableHints = _prefs.getBool('enableHints') ?? false;
    _soundEnabled = _prefs.getBool('soundEnabled') ?? false;
  }

  Future<void> saveSettings() async {
    await _prefs.setInt('difficulty', _difficulty);
    await _prefs.setString('duration', _duration);
    await _prefs.setBool('enableSwing', _enableSwing);
    await _prefs.setBool('enableHints', _enableHints);
    await _prefs.setBool('soundEnabled', _soundEnabled);
  }

  set difficulty(int value) {
    _difficulty = value;
    saveSettings();
  }

  set duration(String value) {
    _duration = value;
    saveSettings();
  }

  set enableSwing(bool value) {
    _enableSwing = value;
    saveSettings();
  }

  set enableHints(bool value) {
    _enableHints = value;
    saveSettings();
  }

  set soundEnabled(bool value) {
    _soundEnabled = value;
    saveSettings();
  }
}
