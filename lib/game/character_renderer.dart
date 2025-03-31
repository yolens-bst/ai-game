import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:tickle_game/game/tickle_game.dart';

enum FaceDirection {
  front, // 正脸
  back, // 背脸
}

class CharacterRenderer {
  final TickleGame game;
  final Vector2 characterAnchor;
  final double headSwing;
  final double armSwing;
  final double legSwing;
  final double eyeOffset;
  final double eyeOpenness;
  final double mouthOpenness;
  final bool enableHints;
  final BodyPart currentTarget;
  final FaceDirection faceDirection;

  CharacterRenderer({
    required this.game,
    required this.characterAnchor,
    required this.headSwing,
    required this.armSwing,
    required this.legSwing,
    required this.eyeOffset,
    required this.eyeOpenness,
    required this.mouthOpenness,
    required this.enableHints,
    this.currentTarget = BodyPart.head,
    this.faceDirection = FaceDirection.front,
  });

  void render(Canvas canvas) {
    _drawCharacter(canvas);
    if (enableHints) {
      _drawHints(canvas);
    }
  }

  void _drawCharacter(Canvas canvas) {
    // 绘制身体
    final bodyPaint = Paint()..color = Colors.orange.shade400;
    final bodyCenter = Offset(characterAnchor.x, characterAnchor.y + 50);
    canvas.drawCircle(
      bodyCenter,
      70, // 与TickleGame中bodyParts[BodyPart.belly]的radius一致
      bodyPaint,
    );

    // 绘制头部
    final headPaint = Paint()..color = Colors.blue.shade200;
    final headCenter = Offset(
      characterAnchor.x + headSwing * 30,
      characterAnchor.y - 90,
    );
    canvas.drawCircle(
      headCenter,
      60, // 与TickleGame中bodyParts[BodyPart.head]的radius一致
      headPaint,
    );

    // 正脸时才绘制眼睛和嘴巴
    if (faceDirection == FaceDirection.front) {
      // 绘制眼睛
      final eyePaint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(
          characterAnchor.x - 15 + headSwing * 30 + eyeOffset,
          characterAnchor.y - 80,
        ),
        8 * eyeOpenness,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(
          characterAnchor.x + 15 + headSwing * 30 + eyeOffset,
          characterAnchor.y - 80,
        ),
        8 * eyeOpenness,
        eyePaint,
      );

      // 绘制嘴巴
      final mouthPaint =
          Paint()
            ..color = Colors.red.shade300
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(
            characterAnchor.x + headSwing * 30,
            characterAnchor.y - 60,
          ),
          width: 30,
          height: 10 + mouthOpenness * 5,
        ),
        0,
        math.pi,
        false,
        mouthPaint,
      );
    } else {
      // 背脸时绘制头发 - 发丝效果
      final hairPaint =
          Paint()
            ..color = Colors.black.withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      // 绘制多缕发丝
      for (var i = 0; i < 15; i++) {
        final offset = i * 6 - 45;
        final path =
            Path()
              ..moveTo(headCenter.dx + offset, headCenter.dy - 30)
              ..quadraticBezierTo(
                headCenter.dx + offset + 10 + headSwing * 15,
                headCenter.dy - 60 - i * 2,
                headCenter.dx + offset * 0.3,
                headCenter.dy - 70 - i * 1.5,
              )
              ..quadraticBezierTo(
                headCenter.dx + offset * 0.5 + headSwing * 15,
                headCenter.dy - 60 - i * 2,
                headCenter.dx + offset,
                headCenter.dy - 30,
              )
              ..lineTo(headCenter.dx + offset, headCenter.dy + 30 - i * 0.5)
              ..quadraticBezierTo(
                headCenter.dx + offset * 0.7,
                headCenter.dy + 40 - i * 0.5,
                headCenter.dx + offset * 0.3,
                headCenter.dy + 30 - i * 0.5,
              );
        canvas.drawPath(path, hairPaint);
      }

      // 绘制头发轮廓
      final outlinePaint =
          Paint()
            ..color = Colors.black.withOpacity(0.6)
            ..style = PaintingStyle.fill;
      final outlinePath =
          Path()
            ..moveTo(headCenter.dx - 50, headCenter.dy - 30)
            ..quadraticBezierTo(
              headCenter.dx - 30 + headSwing * 15,
              headCenter.dy - 60,
              headCenter.dx,
              headCenter.dy - 70,
            )
            ..quadraticBezierTo(
              headCenter.dx + 30 + headSwing * 15,
              headCenter.dy - 60,
              headCenter.dx + 50,
              headCenter.dy - 30,
            )
            ..lineTo(headCenter.dx + 50, headCenter.dy + 30)
            ..quadraticBezierTo(
              headCenter.dx + 30,
              headCenter.dy + 40,
              headCenter.dx,
              headCenter.dy + 40,
            )
            ..quadraticBezierTo(
              headCenter.dx - 30,
              headCenter.dy + 40,
              headCenter.dx - 50,
              headCenter.dy + 30,
            )
            ..close();
      canvas.drawPath(outlinePath, outlinePaint);
    }

    // 更新碰撞检测区域
    game.updateHitAreas(
      headCenter: Offset(
        characterAnchor.x + headSwing * 30,
        characterAnchor.y - 90,
      ),
      headRadius: 60,
      bodyCenter: bodyCenter,
      bodyRadius: 70,
    );

    // 绘制骨骼连接线
    final bonePaint =
        Paint()
          ..color = Colors.blue.shade800.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    // 头部到身体
    canvas.drawLine(
      Offset(characterAnchor.x + headSwing * 30, characterAnchor.y - 20),
      Offset(characterAnchor.x, characterAnchor.y - 30),
      bonePaint,
    );

    // 身体到四肢
    canvas.drawLine(
      Offset(characterAnchor.x - 40, characterAnchor.y + 30),
      Offset(characterAnchor.x - 90, characterAnchor.y + 20 + armSwing * 40),
      bonePaint,
    );
    canvas.drawLine(
      Offset(characterAnchor.x + 40, characterAnchor.y + 30),
      Offset(characterAnchor.x + 90, characterAnchor.y + 20 + armSwing * 40),
      bonePaint,
    );
    // 身体到腿部
    final legLength = 120;
    canvas.drawLine(
      Offset(characterAnchor.x - 20, characterAnchor.y + 60),
      Offset(
        characterAnchor.x - 50 + legSwing * 30,
        characterAnchor.y + 60 + legLength,
      ),
      bonePaint,
    );
    canvas.drawLine(
      Offset(characterAnchor.x + 20, characterAnchor.y + 60),
      Offset(
        characterAnchor.x + 50 + legSwing * 30,
        characterAnchor.y + 60 + legLength,
      ),
      bonePaint,
    );

    // 绘制手部
    final handPaint = Paint()..color = Colors.blue.shade200;
    final leftHandCenter = Offset(
      characterAnchor.x - 100,
      characterAnchor.y + 20 + armSwing * 40,
    );
    final rightHandCenter = Offset(
      characterAnchor.x + 100,
      characterAnchor.y + 20 + armSwing * 40,
    );
    canvas.drawCircle(
      leftHandCenter,
      30, // 与TickleGame中bodyParts[BodyPart.leftHand]的radius一致
      handPaint,
    );
    canvas.drawCircle(
      rightHandCenter,
      30, // 与TickleGame中bodyParts[BodyPart.rightHand]的radius一致
      handPaint,
    );

    // 绘制脚部
    final footPaint = Paint()..color = Colors.blue.shade400;
    final leftFootCenter = Offset(
      characterAnchor.x - 50 + legSwing * 30,
      characterAnchor.y + 180,
    );
    final rightFootCenter = Offset(
      characterAnchor.x + 50 + legSwing * 30,
      characterAnchor.y + 180,
    );
    canvas.drawCircle(
      leftFootCenter,
      30, // 与TickleGame中bodyParts[BodyPart.leftFoot]的radius一致
      footPaint,
    );
    canvas.drawCircle(
      rightFootCenter,
      30, // 与TickleGame中bodyParts[BodyPart.rightFoot]的radius一致
      footPaint,
    );

    // 更新手脚碰撞检测区域
    game.bodyParts[BodyPart.leftHand]?.center = Vector2(
      leftHandCenter.dx,
      leftHandCenter.dy,
    );
    game.bodyParts[BodyPart.rightHand]?.center = Vector2(
      rightHandCenter.dx,
      rightHandCenter.dy,
    );
    game.bodyParts[BodyPart.leftFoot]?.center = Vector2(
      leftFootCenter.dx,
      leftFootCenter.dy,
    );
    game.bodyParts[BodyPart.rightFoot]?.center = Vector2(
      rightFootCenter.dx,
      rightFootCenter.dy,
    );
  }

  void _drawHints(Canvas canvas) {
    final hintPaint =
        Paint()
          ..color = Colors.brown.withOpacity(0.4)
          ..style = PaintingStyle.fill;
    final pulsePaint =
        Paint()
          ..color = Colors.brown.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    // 绘制目标区域高亮
    switch (currentTarget) {
      case BodyPart.head:
        canvas.drawCircle(
          Offset(characterAnchor.x + headSwing * 30, characterAnchor.y - 90),
          60,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(characterAnchor.x + headSwing * 30, characterAnchor.y - 90),
          70,
          pulsePaint,
        );
        break;
      case BodyPart.leftHand:
        canvas.drawCircle(
          Offset(
            characterAnchor.x - 100,
            characterAnchor.y + 20 + armSwing * 40,
          ),
          30,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(
            characterAnchor.x - 100,
            characterAnchor.y + 20 + armSwing * 40,
          ),
          40,
          pulsePaint,
        );
        break;
      case BodyPart.rightHand:
        canvas.drawCircle(
          Offset(
            characterAnchor.x + 100,
            characterAnchor.y + 20 + armSwing * 40,
          ),
          30,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(
            characterAnchor.x + 100,
            characterAnchor.y + 20 + armSwing * 40,
          ),
          40,
          pulsePaint,
        );
        break;
      case BodyPart.leftFoot:
        canvas.drawCircle(
          Offset(
            characterAnchor.x - 50 + legSwing * 30,
            characterAnchor.y + 180,
          ),
          30,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(
            characterAnchor.x - 50 + legSwing * 30,
            characterAnchor.y + 180,
          ),
          40,
          pulsePaint,
        );
        break;
      case BodyPart.rightFoot:
        canvas.drawCircle(
          Offset(
            characterAnchor.x + 50 + legSwing * 30,
            characterAnchor.y + 180,
          ),
          30,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(
            characterAnchor.x + 50 + legSwing * 30,
            characterAnchor.y + 180,
          ),
          40,
          pulsePaint,
        );
        break;
      case BodyPart.belly:
        canvas.drawCircle(
          Offset(characterAnchor.x, characterAnchor.y + 50),
          70,
          hintPaint,
        );
        canvas.drawCircle(
          Offset(characterAnchor.x, characterAnchor.y + 50),
          80,
          pulsePaint,
        );
        break;
    }
  }
}
