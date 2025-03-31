import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'sound_manager.dart';
import 'tickle_game.dart';

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
              const Duration(seconds: 1)) {
        _currentCombo++;
        SoundManager().playCombo(_currentCombo);
        // 触发combo特效
        TickleGame.instance.gameUIRenderer.addComboAnimation(
          _currentCombo,
          Offset(TickleGame.instance.size.x * 0.4, 100),
        );
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
    _comboMultiplier = 1.0 + (_currentCombo ~/ 3) * 0.3;
  }

  void reset() {
    _currentCombo = 0;
    _lastCorrectHitTime = null;
    _comboMultiplier = 1.0;
  }
}
