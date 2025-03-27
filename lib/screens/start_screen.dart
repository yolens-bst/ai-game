import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final SoundManager _soundManager = SoundManager();

  final GameSettings _settings = GameSettings();

  @override
  void initState() {
    super.initState();
    _settings.init().then((_) {
      _soundManager.setEnabled(_settings.soundEnabled);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _soundManager.stopBgm();
    _soundManager.setEnabled(true); // 恢复默认bgm状态
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抓痒痒游戏'),
        centerTitle: true,
        actions: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:
                  _settings.soundEnabled ? Colors.blue[700] : Colors.grey[600],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Icon(
                  _settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
                  key: ValueKey<bool>(_settings.soundEnabled),
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  _settings.soundEnabled = !_settings.soundEnabled;
                  _soundManager.setEnabled(_settings.soundEnabled);
                  if (_settings.soundEnabled) {
                    _soundManager.playBgm(isHome: true);
                  } else {
                    _soundManager.stopBgm();
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
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
                  ),
                  Divider(height: 1),
                  _buildDifficultySelector(),
                  Divider(height: 1),
                  _buildDurationSelector(),
                  Divider(height: 1),
                  _buildSwingToggle(),
                  Divider(height: 1),
                  _buildHintsToggle(),
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
                    ),
                    onPressed: () async {
                      SoundManager().playClick();
                      await _settings.saveSettings();
                      Get.offNamed('/game', arguments: {
                        'difficulty': _settings.difficulty,
                        'duration': _settings.duration,
                        'enableSwing': _settings.enableSwing,
                        'enableHints': _settings.enableHints,
                      });
                    },
                    child: Text(
                      '开始游戏',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
    return ListTile(
      title: Text('难度选择'),
      trailing: SegmentedButton(
        segments: [
          ButtonSegment(value: 0, label: Text('简单')),
          ButtonSegment(value: 1, label: Text('中等')),
          ButtonSegment(value: 2, label: Text('困难')),
        ],
        selected: {_settings.difficulty},
        onSelectionChanged: (newSelection) {
          setState(() {
            _settings.difficulty = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildDurationSelector() {
    return ListTile(
      title: Text('游戏时长'),
      trailing: SegmentedButton(
        segments: [
          ButtonSegment(value: '10秒', label: Text('10秒')),
          ButtonSegment(value: '20秒', label: Text('20秒')),
          ButtonSegment(value: '30秒', label: Text('30秒')),
        ],
        selected: {_settings.duration},
        onSelectionChanged: (newSelection) {
          setState(() {
            _settings.duration = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildSwingToggle() {
    return SwitchListTile(
      title: Text('开启人物摆动'),
      value: _settings.enableSwing,
      onChanged: (value) {
        setState(() {
          _settings.enableSwing = value;
        });
      },
    );
  }

  Widget _buildHintsToggle() {
    return SwitchListTile(
      title: Text('显示辅助提示'),
      value: _settings.enableHints,
      onChanged: (value) {
        setState(() {
          _settings.enableHints = value;
        });
      },
    );
  }
}
