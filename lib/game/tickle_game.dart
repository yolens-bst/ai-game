import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:get/get.dart';
import '../models/game_result.dart';
import 'combo_system.dart';
import '../components/game_result_dialog.dart';
import 'character_renderer.dart';
import 'game_ui_renderer.dart';
import 'sound_manager.dart';

enum GameState { waiting, playing, gameOver }

enum BodyPart { head, belly, leftHand, rightHand, leftFoot, rightFoot }

class Circle {
  Vector2 center;
  double radius;

  Circle({required this.center, this.radius = 30});
}

class TickleGame extends FlameGame with TapCallbacks {
  final int difficulty;
  final bool enableSwing;
  final bool enableHints;
  final double totalGameTime;
  final SoundManager _soundManager = SoundManager();

  TickleGame({
    required this.difficulty,
    required this.enableSwing,
    required this.enableHints,
    required this.totalGameTime,
  });

  // 游戏状态
  GameState gameState = GameState.waiting;
  double gameTimeLeft = 0;
  double questionTimeLeft = 0;
  BodyPart? currentTarget;
  int score = 0;
  int correctTaps = 0;
  int wrongTaps = 0;
  int preciseHits = 0;
  List<double> responseTimes = [];
  double startQuestionTime = 0;
  Stopwatch gameTimer = Stopwatch();
  final ComboSystem comboSystem = ComboSystem();

  // 角色动画状态
  double timer = 0;
  final Random _random = Random();
  double eyeOffset = 0;
  double mouthOpenness = 0;
  double headSwing = 0;
  double armSwing = 0;
  double legSwing = 0;
  final double swingSpeed = 1.5;
  double eyeOpenness = 1.0;
  bool isBlinking = false;

  // 角色部位定义
  Vector2 get characterAnchor => Vector2(size.x / 2, size.y / 2);
  late final Map<BodyPart, Circle> bodyParts;

  // 渲染器
  late CharacterRenderer characterRenderer;
  late GameUIRenderer gameUIRenderer;

  @override
  Color backgroundColor() => material.Color(0xFFF5F5F5);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _soundManager.playBgm(isHome: false);
    _initBodyParts();
    camera.viewfinder.visibleGameSize = Vector2(size.x, size.y);
    camera.viewfinder.position = Vector2(size.x / 2, size.y / 2);
    camera.viewfinder.anchor = Anchor.center;

    characterRenderer = CharacterRenderer(
      game: this,
      characterAnchor: characterAnchor,
      headSwing: headSwing,
      armSwing: armSwing,
      legSwing: legSwing,
      eyeOffset: eyeOffset,
      eyeOpenness: eyeOpenness,
      mouthOpenness: mouthOpenness,
      enableHints: enableHints,
      currentTarget: currentTarget ?? BodyPart.head,
    );

    // 延迟初始化UI渲染器
    _initUIRenderer();
    startGame();
  }

  void updateHitAreas({
    required Offset headCenter,
    required double headRadius,
    required Offset bodyCenter,
    required double bodyRadius,
  }) {
    bodyParts[BodyPart.head] = Circle(
      center: Vector2(headCenter.dx, headCenter.dy),
      radius: headRadius,
    );
    bodyParts[BodyPart.belly] = Circle(
      center: Vector2(bodyCenter.dx, bodyCenter.dy),
      radius: bodyRadius,
    );
  }

  void startGame() {
    _initUIRenderer();
    gameTimeLeft = totalGameTime;
    score = 0;
    correctTaps = 0;
    wrongTaps = 0;
    preciseHits = 0;
    responseTimes.clear();
    gameTimer.reset();
    gameState = GameState.playing;

    timer = 0;
    eyeOffset = 0;
    mouthOpenness = 0;
    headSwing = 0;
    armSwing = 0;
    legSwing = 0;
    eyeOpenness = 1.0;
    isBlinking = false;

    _nextQuestion();
    gameTimer.start();
  }

  void _initUIRenderer() {
    gameUIRenderer = GameUIRenderer(
      width: size.x,
      difficulty: difficulty,
      gameTimeLeft: gameTimeLeft,
      questionTimeLeft: questionTimeLeft,
      score: score,
      targetBodyPart: currentTarget,
    );
  }

  void _initBodyParts() {
    bodyParts = {
      BodyPart.head:
          Circle(center: characterAnchor + Vector2(0, -90), radius: 60),
      BodyPart.belly:
          Circle(center: characterAnchor + Vector2(0, 50), radius: 70),
      BodyPart.leftHand:
          Circle(center: characterAnchor + Vector2(-120, 20), radius: 30),
      BodyPart.rightHand:
          Circle(center: characterAnchor + Vector2(120, 20), radius: 30),
      BodyPart.leftFoot:
          Circle(center: characterAnchor + Vector2(-50, 180), radius: 30),
      BodyPart.rightFoot:
          Circle(center: characterAnchor + Vector2(50, 180), radius: 30),
    };
  }

  BodyPart? _lastTarget;

  void _nextQuestion() {
    if (startQuestionTime > 0) {
      responseTimes.add(questionTimeLeft);
    }
    startQuestionTime = questionTimeLeft;

    final parts = BodyPart.values;
    BodyPart newTarget;
    do {
      newTarget = parts[_random.nextInt(parts.length)];
      _lastTarget = currentTarget; // 在循环内更新_lastTarget
    } while (newTarget == currentTarget); // 确保新目标不等于当前目标

    currentTarget = newTarget;

    questionTimeLeft = difficulty == 0
        ? 5
        : difficulty == 1
            ? 3
            : 2;
  }

  void endGame() {
    gameTimer.stop();
    _soundManager.stopBgm();
    // 过滤掉无效响应时间(<=0)
    final validResponseTimes = responseTimes.where((t) => t > 0).toList();
    final result = GameResult(
        totalScore: score,
        fastestResponse:
            validResponseTimes.isNotEmpty ? validResponseTimes.reduce(min) : 0,
        slowestResponse:
            validResponseTimes.isNotEmpty ? validResponseTimes.reduce(max) : 0,
        averageResponse: validResponseTimes.isNotEmpty
            ? validResponseTimes.reduce((a, b) => a + b) /
                validResponseTimes.length
            : 0,
        isSuccess: score >= 5,
        correctTaps: correctTaps,
        wrongTaps: wrongTaps,
        accuracy: correctTaps + wrongTaps > 0
            ? correctTaps / (correctTaps + wrongTaps)
            : 0,
        preciseHits: preciseHits);

    Get.dialog(
      GameResultDialog(result: result),
      barrierDismissible: false,
    ).then((value) {
      if (value == 'restart') {
        startGame();
      } else if (value == 'home') {
        Get.offAllNamed('/');
      } else {
        gameState = GameState.waiting;
        gameTimeLeft = 0;
        questionTimeLeft = 0;
        currentTarget = null;
        score = 0;
        correctTaps = 0;
        wrongTaps = 0;
        preciseHits = 0;
        responseTimes.clear();
        gameTimer.reset();

        timer = 0;
        eyeOffset = 0;
        mouthOpenness = 0;
        headSwing = 0;
        armSwing = 0;
        legSwing = 0;
        eyeOpenness = 1.0;
        isBlinking = false;

        _initBodyParts();
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateAnimations(dt);

    if (gameState == GameState.playing) {
      gameTimeLeft = max(0, gameTimeLeft - dt);
      questionTimeLeft = max(0, questionTimeLeft - dt);

      if (gameTimeLeft <= 0) {
        gameState = GameState.gameOver;
        endGame();
      } else if (questionTimeLeft <= 0) {
        _nextQuestion();
      }
    }

    // 更新角色渲染器状态
    characterRenderer = CharacterRenderer(
      game: this,
      characterAnchor: characterAnchor,
      headSwing: headSwing,
      armSwing: armSwing,
      legSwing: legSwing,
      eyeOffset: eyeOffset,
      eyeOpenness: eyeOpenness,
      mouthOpenness: mouthOpenness,
      enableHints: enableHints,
      currentTarget: currentTarget ?? BodyPart.head,
    );

    // 更新UI渲染器状态
    gameUIRenderer = GameUIRenderer(
      width: size.x,
      difficulty: difficulty,
      gameTimeLeft: gameTimeLeft,
      questionTimeLeft: questionTimeLeft,
      score: score,
      targetBodyPart: currentTarget,
    );
  }

  void _updateAnimations(double dt) {
    if (!enableSwing) return;

    if (!isBlinking && _random.nextDouble() < 0.005) {
      isBlinking = true;
    }

    if (isBlinking) {
      eyeOpenness = max(0.0, eyeOpenness - dt * 5);
      if (eyeOpenness <= 0.0) {
        eyeOpenness = 0.0;
        isBlinking = false;
      }
    } else {
      eyeOpenness = min(1.0, eyeOpenness + dt * 3);
    }

    eyeOffset = sin(timer * 2) * 3;
    mouthOpenness = max(0, sin(timer) * 5);
    headSwing = sin(timer * swingSpeed) * 0.2;
    armSwing = sin(timer * swingSpeed * 1.2) * 0.3;
    legSwing = sin(timer * swingSpeed * 0.8) * 0.4;
    timer += dt;
    _updateBodyPartsPosition();
  }

  void _updateBodyPartsPosition() {
    bodyParts[BodyPart.head]?.center =
        characterAnchor + Vector2(headSwing * 30, -90);
    bodyParts[BodyPart.leftHand]?.center =
        characterAnchor + Vector2(-120, 20 + armSwing * 40);
    bodyParts[BodyPart.rightHand]?.center =
        characterAnchor + Vector2(120, 20 + armSwing * 40);
    bodyParts[BodyPart.leftFoot]?.center =
        characterAnchor + Vector2(-50 + legSwing * 30, 180);
    bodyParts[BodyPart.rightFoot]?.center =
        characterAnchor + Vector2(50 + legSwing * 30, 180);

    // 更新半径以匹配视觉尺寸
    bodyParts[BodyPart.head]?.radius = 60;
    bodyParts[BodyPart.belly]?.radius = 70;
    bodyParts[BodyPart.leftHand]?.radius = 30;
    bodyParts[BodyPart.rightHand]?.radius = 30;
    bodyParts[BodyPart.leftFoot]?.radius = 30;
    bodyParts[BodyPart.rightFoot]?.radius = 30;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (gameState != GameState.playing) return;

    final touchPos = event.localPosition;
    bodyParts.forEach((part, circle) {
      final distance = touchPos.distanceTo(circle.center);
      if (distance < circle.radius) {
        if (part == currentTarget) {
          correctTaps++; // 增加正确点击统计
          // 计算距离得分 (距离越近得分越高)
          final distanceScore = 10 - (distance / circle.radius) * 5;
          // 应用连击加成
          final comboMultiplier = comboSystem.comboMultiplier;
          final points = (distanceScore * comboMultiplier).ceil();
          score += points;
          comboSystem.recordHit(true, DateTime.now());
          SoundManager().playCorrect();

          // 添加得分动画 (从点击位置开始)
          gameUIRenderer.addScoreAnimation(
              points, Offset(touchPos.x, touchPos.y));

          // 记录精准点击 (距离小于半径1/3)
          if (distance < circle.radius / 3) {
            preciseHits++;
          }

          responseTimes.add(questionTimeLeft);
          _nextQuestion();
        } else {
          wrongTaps++;
          SoundManager().playWrong();
          _nextQuestion();
        }
      }
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 保存当前画布状态
    canvas.save();

    // 绘制角色区域（留出顶部100像素给UI）
    canvas.clipRect(Rect.fromLTWH(0, 100, size.x, size.y - 100));
    characterRenderer.render(canvas);
    canvas.restore();

    // 绘制UI面板（包含得分动画）
    gameUIRenderer.render(canvas);
  }
}
