import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'game/tickle_game.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '抓痒痒游戏',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => StartScreen()),
        GetPage(
          name: '/game',
          page: () {
            final args = Get.arguments ?? {};
            return GameScreen(
              difficulty: args['difficulty'] ?? '中等',
              duration: args['duration'] ?? '30秒',
              enableSwing: args['enableSwing'] ?? true,
              enableHints: args['enableHints'] ?? true,
            );
          },
        ),
      ],
    );
  }
}

class GameScreen extends StatelessWidget {
  final int difficulty;
  final String duration;
  final bool enableSwing;
  final bool enableHints;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.duration,
    required this.enableSwing,
    required this.enableHints,
  });

  double _parseDuration(String duration) {
    return double.parse(duration.replaceAll('秒', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抓痒痒游戏'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Get.offAndToNamed('/'),
            tooltip: '退出游戏',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: GameWidget(
                game: TickleGame(
                  difficulty: difficulty,
                  enableSwing: enableSwing,
                  enableHints: enableHints,
                  totalGameTime: _parseDuration(duration),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
