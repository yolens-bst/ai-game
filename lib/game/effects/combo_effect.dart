import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'base_effect.dart';
import 'effect_type.dart';
import 'dart:math' as math;

class ComboEffect extends BaseEffect {
  final int combo;
  final DateTime startTime;
  final Offset position;

  ComboEffect(this.combo, this.position) : startTime = DateTime.now();

  @override
  EffectType get type => EffectType.combo;

  @override
  bool get isExpired =>
      DateTime.now().difference(startTime) > Duration(milliseconds: 1500);

  @override
  int get zIndex => 100;

  @override
  void renderEffect(Canvas canvas) {
    final progress =
        DateTime.now().difference(startTime).inMilliseconds / 1500.0;
    final opacity = 1.0 - progress;
    final yOffset = 30 * progress;
    final xOffset = 15 * math.sin(progress * math.pi * 2);
    final offset = Offset(position.dx + xOffset, position.dy + yOffset);

    final textStyle = TextStyle(
      color: Colors.redAccent[700]!.withOpacity(opacity),
      fontSize: 32 + 16 * progress,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(opacity * 0.8),
          blurRadius: 6,
          offset: Offset(2, 2),
        ),
      ],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: 'COMBO +$combo', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  void updateEffect(double dt) {
    // 无需额外更新逻辑
  }
}
