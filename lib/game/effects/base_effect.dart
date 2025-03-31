import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'effect_type.dart';

abstract class BaseEffect extends Component {
  EffectType get type;
  bool _isExpired = false;
  bool get isExpired => _isExpired;
  int get zIndex;

  void markExpired() {
    _isExpired = true;
  }

  @override
  void render(Canvas canvas) {
    if (isExpired) return;
    renderEffect(canvas);
  }

  void renderEffect(Canvas canvas);

  @override
  void update(double dt) {
    if (isExpired) return;
    updateEffect(dt);
  }

  void updateEffect(double dt);
}
