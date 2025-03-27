import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'base_effect.dart';
import 'effect_type.dart';
import 'dart:math' as math;

class ScoreEffect extends BaseEffect {
  final int score;
  final Offset position;
  final DateTime startTime;

  ScoreEffect(this.score, this.position) : startTime = DateTime.now();

  @override
  EffectType get type => EffectType.score;

  @override
  bool get isExpired =>
      DateTime.now().difference(startTime) > Duration(milliseconds: 1000);

  @override
  int get zIndex => 100;

  @override
  void renderEffect(Canvas canvas) {
    final progress =
        DateTime.now().difference(startTime).inMilliseconds / 1000.0;
    final opacity = 1.0 - progress;
    final yOffset = 20 * progress;
    final xOffset = 10 * math.sin(progress * math.pi * 2);
    final offset = Offset(
      position.dx + xOffset,
      position.dy + yOffset,
    );

    final textStyle = TextStyle(
      color: Colors.yellow[700]!.withOpacity(opacity),
      fontSize: 28 + 12 * progress,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(opacity * 0.8),
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
      ],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: '+$score', style: textStyle),
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
