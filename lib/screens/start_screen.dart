import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';

class StartScreen extends StatelessWidget {
  final RxString difficulty = '中等'.obs;
  final RxString duration = '30秒'.obs;
  final RxBool enableSwing = true.obs;
  final RxBool enableHints = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抓痒痒游戏'),
        centerTitle: true,
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
                    onPressed: () {
                      SoundManager().playClick();
                      Get.offNamed('/game', arguments: {
                        'difficulty': difficulty.value,
                        'duration': duration.value,
                        'enableSwing': enableSwing.value,
                        'enableHints': enableHints.value,
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    onPressed: () {
                      SoundManager().playClick();
                      Get.back();
                    },
                    child: Text(
                      '退出游戏',
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
    return Obx(() => ListTile(
          title: Text('难度选择'),
          trailing: SegmentedButton(
            segments: [
              ButtonSegment(value: '简单', label: Text('简单')),
              ButtonSegment(value: '中等', label: Text('中等')),
              ButtonSegment(value: '困难', label: Text('困难')),
            ],
            selected: {difficulty.value},
            onSelectionChanged: (newSelection) {
              difficulty.value = newSelection.first;
            },
          ),
        ));
  }

  Widget _buildDurationSelector() {
    return Obx(() => ListTile(
          title: Text('游戏时长'),
          trailing: SegmentedButton(
            segments: [
              ButtonSegment(value: '10秒', label: Text('10秒')),
              ButtonSegment(value: '30秒', label: Text('30秒')),
            ],
            selected: {duration.value},
            onSelectionChanged: (newSelection) {
              duration.value = newSelection.first;
            },
          ),
        ));
  }

  Widget _buildSwingToggle() {
    return Obx(() => SwitchListTile(
          title: Text('开启人物摆动'),
          value: enableSwing.value,
          onChanged: (value) => enableSwing.value = value,
        ));
  }

  Widget _buildHintsToggle() {
    return Obx(() => SwitchListTile(
          title: Text('显示辅助提示'),
          value: enableHints.value,
          onChanged: (value) => enableHints.value = value,
        ));
  }
}
