import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tickle_game/game/sound_manager.dart';
import 'game/tickle_game.dart';
import 'screens/start_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'models/game_settings.dart';
import 'controllers/game_settings_controller.dart';
import 'controllers/leaderboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(GameSettingsController());
  Get.put(LeaderboardController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '抓痒痒',
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
            return GameScreen();
          },
        ),
      ],
    );
  }
}

class GameScreen extends StatelessWidget {
  final GameSettingsController _settingsController =
      Get.find<GameSettingsController>();

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => SoundManager().playClick(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('抓痒痒'),
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
                  game: TickleGame(settings: _settingsController.settings),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
