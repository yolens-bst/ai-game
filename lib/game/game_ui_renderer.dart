import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tickle_game/game/character_renderer.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../game/tickle_game.dart';
import '../models/game_settings.dart';
import 'effects/effect_layer.dart';
import 'effects/score_effect.dart';
import 'effects/combo_effect.dart';

class GameUIRenderer {
  final double width;
  final int score;
  final double questionTimeLeft;
  final double gameTimeLeft;
  final DifficultyLevel difficulty;
  final BodyPart? targetBodyPart;
  final EffectLayer effectLayer = EffectLayer();
  final FaceDirection faceDirection;

  GameUIRenderer({
    required this.width,
    required this.score,
    required this.questionTimeLeft,
    required this.gameTimeLeft,
    required this.difficulty,
    this.targetBodyPart,
    this.faceDirection = FaceDirection.front,
  });

  void addScoreAnimation(int score, Offset position) {
    if (score > 0) {
      effectLayer.addEffect(ScoreEffect(score, position));
    }
  }

  void addComboAnimation(int combo, Offset position) {
    if (combo > 1) {
      effectLayer.addEffect(ComboEffect(combo, position));
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
    final scoreText = material.TextSpan(
      text: '${'scoreLabel'.tr}: $score',
      style: textStyle,
    );
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
      text:
          gameTimeLeft == double.infinity
              ? 'endlessMode'.tr
              : '${'timeLeftLabel'.tr}: ${gameTimeLeft.toInt()}s',
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
      text:
          '${_getBodyPartName(targetBodyPart!)}\n${faceDirection == FaceDirection.back ? 'FtoB'.tr : 'FtoF'.tr}',
      style: material.TextStyle(
        color: material.Colors.black,
        fontSize: 18,
        fontWeight: material.FontWeight.bold,
      ),
    );
    final targetPainter = material.TextPainter(
      text: targetText,
      textDirection: material.TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    targetPainter.layout();
    targetPainter.paint(
      canvas,
      Offset(
        (width - targetPainter.width) / 2,
        50 + (targetHeight - targetPainter.height) / 2,
      ),
    );
  }

  String _getBodyPartName(BodyPart part) {
    bool isFaceFront = faceDirection == FaceDirection.front;
    switch (part) {
      case BodyPart.head:
        return 'headPart'.tr;
      case BodyPart.belly:
        return 'bellyPart'.tr;
      case BodyPart.leftHand:
        return isFaceFront ? 'rightHandPart'.tr : 'leftHandPart'.tr;
      case BodyPart.rightHand:
        return isFaceFront ? 'leftHandPart'.tr : 'rightHandPart'.tr;
      case BodyPart.leftFoot:
        return isFaceFront ? 'rightFootPart'.tr : 'leftFootPart'.tr;
      case BodyPart.rightFoot:
        return isFaceFront ? 'leftFootPart'.tr : 'rightFootPart'.tr;
    }
  }
}
