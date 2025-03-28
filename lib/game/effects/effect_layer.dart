import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'base_effect.dart';

class EffectLayer extends Component {
  static final EffectLayer _instance = EffectLayer._internal();

  factory EffectLayer() {
    return _instance;
  }

  EffectLayer._internal();

  final List<BaseEffect> _effects = [];

  void addEffect(BaseEffect effect) {
    _effects.add(effect);
  }

  @override
  void render(Canvas canvas) {
    _effects
      ..removeWhere((effect) => effect.isExpired)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex))
      ..forEach((effect) => effect.render(canvas));
  }

  @override
  void update(double dt) {
    _effects.forEach((effect) => effect.update(dt));
  }

  void clear() {
    _effects.clear();
  }
}
