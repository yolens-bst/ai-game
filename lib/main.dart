import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tickle_game/game/sound_manager.dart';
import 'package:tickle_game/languages/translations.dart';
import 'game/tickle_game.dart';
import 'screens/start_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'models/game_settings.dart';
import 'controllers/game_settings_controller.dart';
import 'controllers/leaderboard_controller.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:audio_session/audio_session.dart';

Future<void> _initAudioSession() async {
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music()); // 允许后台播放
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initAudioSession();
  await GetStorage.init();
  Get.put(GameSettingsController());
  Get.put(LeaderboardController());

  // Set window size to 860x720 and disable resizing
  if (GetPlatform.isDesktop) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: 'appTitle'.tr,
        primaryColor: Colors.blue.value,
      ),
    );
    // Set fixed window size for desktop
    await WindowManager.instance.ensureInitialized();
    await WindowManager.instance.setSize(const Size(860, 720));
    await WindowManager.instance.setResizable(false);
    await WindowManager.instance.setMinimumSize(const Size(860, 720));
    await WindowManager.instance.setMaximumSize(const Size(860, 720));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'appTitle'.tr,
      translations: Languages(),
      locale:
          Get.find<GameSettingsController>().settings.language == 'zh_CN'
              ? const Locale('zh', 'CN')
              : const Locale('en', 'US'),
      fallbackLocale: const Locale('zh', 'CN'),
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
      onPopInvokedWithResult: (didPop, result) => {SoundManager().playClick()},
      child: Scaffold(
        appBar: AppBar(
          title: Text('appTitle'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => Get.offAndToNamed('/'),
              tooltip: 'exitGame'.tr,
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
