import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';
import './rules_screen.dart';
import './leaderboard_screen.dart';
import '../controllers/game_settings_controller.dart';

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
        title: Text('抓痒痒'),
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
                      '游戏设置',
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
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 0),
                      foregroundColor: Colors.white,
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
                      '开始游戏',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      SoundManager().playClick();
                      Get.to(
                        () =>
                            RulesScreen(settings: _settingsController.settings),
                      );
                    },
                    child: Text(
                      '查看游戏规则',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade700,
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

  Widget _buildDifficultySelector() {
    return Obx(
      () => ListTile(
        title: Text('难度选择'),
        trailing: SegmentedButton<DifficultyLevel>(
          segments: [
            ButtonSegment(value: DifficultyLevel.easy, label: Text('简单')),
            ButtonSegment(value: DifficultyLevel.medium, label: Text('中等')),
            ButtonSegment(value: DifficultyLevel.hard, label: Text('困难')),
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
        title: Text('游戏时长'),
        trailing: SegmentedButton<double>(
          segments: [
            ButtonSegment(value: 10, label: Text('10秒')),
            ButtonSegment(value: 20, label: Text('20秒')),
            ButtonSegment(value: 30, label: Text('30秒')),
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
        title: Text('开启人物摆动'),
        value: _settingsController.settings.enableSwing,
        onChanged: _settingsController.setEnableSwing,
      ),
    );
  }

  Widget _buildHintsToggle() {
    return Obx(
      () => SwitchListTile(
        title: Text('显示辅助提示'),
        value: _settingsController.settings.enableHints,
        onChanged: _settingsController.setEnableHints,
      ),
    );
  }

  Widget _buildVibrationToggle() {
    return Obx(
      () => SwitchListTile(
        title: Text('开启振动反馈'),
        value: _settingsController.settings.vibrationEnabled,
        onChanged: _settingsController.setVibrationEnabled,
      ),
    );
  }

  Widget _buildPlayerNameInput() {
    return Obx(
      () => ListTile(
        title: Text('玩家名称'),
        trailing: SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: TextField(
              controller: TextEditingController(
                text: _settingsController.settings.playerName,
              ),
              decoration: InputDecoration(
                hintText: '输入昵称',
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
