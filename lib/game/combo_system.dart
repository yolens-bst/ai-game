import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'sound_manager.dart';

class ComboSystem {
  int _currentCombo = 0;
  DateTime? _lastCorrectHitTime;
  double _comboMultiplier = 1.0;

  int get currentCombo => _currentCombo;
  double get comboMultiplier => _comboMultiplier;

  void recordHit(bool isCorrect, DateTime hitTime) {
    if (isCorrect) {
      if (_lastCorrectHitTime != null &&
          hitTime.difference(_lastCorrectHitTime!) <
              const Duration(seconds: 2)) {
        _currentCombo++;
        SoundManager().playCombo(_currentCombo);
      } else {
        _currentCombo = 1;
      }
      _lastCorrectHitTime = hitTime;
      _updateMultiplier();
    } else {
      _currentCombo = 0;
      _comboMultiplier = 1.0;
    }
  }

  void _updateMultiplier() {
    _comboMultiplier = 1.0 + (_currentCombo ~/ 5) * 0.3;
  }

  void reset() {
    _currentCombo = 0;
    _lastCorrectHitTime = null;
    _comboMultiplier = 1.0;
  }
}
