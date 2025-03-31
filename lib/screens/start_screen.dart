import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';
import './rules_screen.dart';
import './leaderboard_screen.dart';
import '../controllers/game_settings_controller.dart';
import '../languages/translations.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  final SoundManager _soundManager = SoundManager();
  final GameSettingsController _settingsController =
      Get.find<GameSettingsController>();

  @override
  void initState() {
    super.initState();
    if (_settingsController.settings.soundEnabled) {
      _soundManager.playBgm(isHome: true);
    }
  }

  @override
  void dispose() {
    _soundManager.stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr),
        centerTitle: true,
        actions: [
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color:
                    _settingsController.settings.soundEnabled
                        ? Colors.blue[700]
                        : Colors.grey[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    _settingsController.settings.soundEnabled
                        ? Icons.volume_up
                        : Icons.volume_off,
                    key: ValueKey<bool>(
                      _settingsController.settings.soundEnabled,
                    ),
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _settingsController.toggleSound();
                  if (_settingsController.settings.soundEnabled) {
                    _soundManager.playBgm(isHome: true);
                  } else {
                    _soundManager.stopBgm();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'gameSettings'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.leaderboard),
                      onPressed: () {
                        SoundManager().playClick();
                        Get.to(
                          () => LeaderboardScreen(
                            settings: _settingsController.settings,
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(height: 1),
                  _buildPlayerNameInput(),
                  Divider(height: 1),
                  _buildLanguageSelector(),
                  Divider(height: 1),
                  _buildDifficultySelector(),
                  Divider(height: 1),
                  _buildDurationSelector(),
                  Divider(height: 1),
                  _buildSwingToggle(),
                  Divider(height: 1),
                  _buildHintsToggle(),
                  Divider(height: 1),
                  _buildVibrationToggle(),
                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      elevation: 8,
                    ),
                    onPressed: () async {
                      SoundManager().playClick();
                      await _settingsController.saveSettings();
                      Get.offNamed(
                        '/game',
                        arguments: _settingsController.settings.toJson(),
                      );
                    },
                    child: Text(
                      'startGame'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      SoundManager().playClick();
                      Get.to(
                        () =>
                            RulesScreen(settings: _settingsController.settings),
                      );
                    },
                    child: Text(
                      'viewRules'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Obx(
      () => ListTile(
        title: Text('language'.tr),
        trailing: DropdownButton<String>(
          value: _settingsController.settings.language,
          items: [
            DropdownMenuItem(value: 'zh_CN', child: Text('chinese'.tr)),
            DropdownMenuItem(value: 'en_US', child: Text('english'.tr)),
          ],
          onChanged: (value) {
            if (value != null) {
              _settingsController.setLanguage(value);
              Get.updateLocale(Locale(value));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Obx(
      () => ListTile(
        title: Text('difficultyLevel'.tr),
        trailing: SegmentedButton<DifficultyLevel>(
          segments: [
            ButtonSegment(value: DifficultyLevel.easy, label: Text('easy'.tr)),
            ButtonSegment(
              value: DifficultyLevel.medium,
              label: Text('medium'.tr),
            ),
            ButtonSegment(value: DifficultyLevel.hard, label: Text('hard'.tr)),
          ],
          selected: {_settingsController.settings.difficulty},
          onSelectionChanged: (newSelection) {
            _settingsController.setDifficulty(newSelection.first);
          },
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Obx(
      () => ListTile(
        title: Text('gameDuration'.tr),
        trailing: SegmentedButton<double>(
          segments: [
            ButtonSegment(value: 10, label: Text('10seconds'.tr)),
            ButtonSegment(value: 30, label: Text('30seconds'.tr)),
            ButtonSegment(
              value: double.infinity,
              label: Text('endlessMode'.tr),
            ),
          ],
          selected: {_settingsController.settings.duration},
          onSelectionChanged: (newSelection) {
            _settingsController.setDuration(newSelection.first);
          },
        ),
      ),
    );
  }

  Widget _buildSwingToggle() {
    return Obx(
      () => SwitchListTile(
        title: Text('enableSwing'.tr),
        value: _settingsController.settings.enableSwing,
        onChanged: _settingsController.setEnableSwing,
      ),
    );
  }

  Widget _buildHintsToggle() {
    return Obx(
      () => SwitchListTile(
        title: Text('showHints'.tr),
        value: _settingsController.settings.enableHints,
        onChanged: _settingsController.setEnableHints,
      ),
    );
  }

  Widget _buildVibrationToggle() {
    return Obx(
      () => SwitchListTile(
        title: Text('enableVibration'.tr),
        value: _settingsController.settings.vibrationEnabled,
        onChanged: _settingsController.setVibrationEnabled,
      ),
    );
  }

  Widget _buildPlayerNameInput() {
    return Obx(
      () => ListTile(
        title: Text('playerName'.tr),
        trailing: SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: TextField(
              controller: TextEditingController(
                text: _settingsController.settings.playerName,
              ),
              decoration: InputDecoration(
                hintText: 'enterNicknameHint'.tr,
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              style: TextStyle(fontSize: 14),
              cursorColor: Colors.blue,
              onChanged: _settingsController.setPlayerName,
            ),
          ),
        ),
      ),
    );
  }
}
