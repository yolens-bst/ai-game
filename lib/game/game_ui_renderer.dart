import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../game/tickle_game.dart';
import '../models/game_settings.dart';
import 'effects/effect_layer.dart';
import 'effects/score_effect.dart';

class GameUIRenderer {
  final double width;
  final int score;
  final double questionTimeLeft;
  final double gameTimeLeft;
  final DifficultyLevel difficulty;
  final BodyPart? targetBodyPart;
  final EffectLayer effectLayer = EffectLayer();

  GameUIRenderer({
    required this.width,
    required this.score,
    required this.questionTimeLeft,
    required this.gameTimeLeft,
    required this.difficulty,
    this.targetBodyPart,
  });

  void addScoreAnimation(int score, Offset position) {
    if (score > 0) {
      effectLayer.addEffect(ScoreEffect(score, position));
    }
  }

  void render(Canvas canvas) {
    // 先绘制UI面板
    _drawGameInfo(canvas);
    _drawTargetPart(canvas);

    // 保存当前画布状态
    canvas.save();
    // 解除裁剪区域限制
    canvas.clipRect(Rect.fromLTWH(0, 0, width, double.infinity));
    // 绘制特效（不受UI面板高度限制）
    effectLayer.render(canvas);
    // 恢复画布状态
    canvas.restore();
  }

  void _drawGameInfo(Canvas canvas) {
    final textStyle = material.TextStyle(
      color: material.Colors.black,
      fontSize: 18,
    );
    const infoHeight = 40.0;
    const progressRadius = 20.0;

    // 绘制分数（左上角）
    final scoreText = material.TextSpan(text: '分数: $score', style: textStyle);
    final scorePainter = material.TextPainter(
      text: scoreText,
      textDirection: material.TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(
      canvas,
      Offset(20, (infoHeight - scorePainter.height) / 2),
    );

    // 绘制环形进度条（中间）
    final centerX = width / 2;
    final progress =
        questionTimeLeft /
        (difficulty == DifficultyLevel.easy
            ? 5
            : difficulty == DifficultyLevel.medium
            ? 3
            : 2);
    final color =
        material.Color.lerp(
          material.Colors.redAccent,
          material.Colors.blue,
          progress,
        )!;

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, infoHeight / 2 + 5),
        radius: progressRadius,
      ),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );

    // 在进度条中间显示剩余时间
    final timeText = material.TextSpan(
      text: '${questionTimeLeft.toStringAsFixed(1)}s',
      style: textStyle.copyWith(fontSize: 14),
    );
    final timePainter = material.TextPainter(
      text: timeText,
      textDirection: material.TextDirection.ltr,
    );
    timePainter.layout();
    timePainter.paint(
      canvas,
      Offset(
        centerX - timePainter.width / 2,
        infoHeight / 2 - timePainter.height / 2 + 5,
      ),
    );

    // 绘制总时间（右上角）
    final totalTimeText = material.TextSpan(
      text: '剩余: ${gameTimeLeft.toInt()}s',
      style: textStyle,
    );
    final totalTimePainter = material.TextPainter(
      text: totalTimeText,
      textDirection: material.TextDirection.ltr,
    );
    totalTimePainter.layout();
    totalTimePainter.paint(
      canvas,
      Offset(
        width - totalTimePainter.width - 20,
        (infoHeight - totalTimePainter.height) / 2,
      ),
    );
  }

  void _drawTargetPart(Canvas canvas) {
    if (targetBodyPart == null) return;

    const targetHeight = 60.0;
    final targetText = material.TextSpan(
      text: '点击: ${_getBodyPartName(targetBodyPart!)}',
      style: material.TextStyle(
        color: material.Colors.black,
        fontSize: 24,
        fontWeight: material.FontWeight.bold,
      ),
    );
    final targetPainter = material.TextPainter(
      text: targetText,
      textDirection: material.TextDirection.ltr,
    );
    targetPainter.layout();
    targetPainter.paint(
      canvas,
      Offset(
        (width - targetPainter.width) / 2,
        40 + (targetHeight - targetPainter.height) / 2,
      ),
    );
  }

  String _getBodyPartName(BodyPart part) {
    switch (part) {
      case BodyPart.head:
        return '头部';
      case BodyPart.belly:
        return '肚子';
      case BodyPart.leftHand:
        return '左手';
      case BodyPart.rightHand:
        return '右手';
      case BodyPart.leftFoot:
        return '左脚';
      case BodyPart.rightFoot:
        return '右脚';
    }
  }
}
