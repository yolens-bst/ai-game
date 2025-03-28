import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';

class RulesScreen extends StatelessWidget {
  final GameSettings settings;

  const RulesScreen({super.key, required this.settings});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => SoundManager().playClick(),
      child: Scaffold(
        appBar: AppBar(title: Text('游戏规则'), centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '抓痒痒游戏规则',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. 游戏目标：在规定时间内尽可能多地点击出现的痒痒点\n'
                '2. 难度说明：\n'
                '   - 简单：痒痒点移动速度慢，出现频率低\n'
                '   - 中等：痒痒点移动速度中等，出现频率中等\n'
                '   - 困难：痒痒点移动速度快，出现频率高\n'
                '3. 计分规则：\n'
                '   - 每次点击正确位置得10分\n'
                '   - 连续点击正确可获得连击加分\n'
                '4. 游戏时长：10秒/20秒/30秒可选\n'
                '5. 特殊效果：\n'
                '   - 开启人物摆动会增加游戏难度\n'
                '   - 显示辅助提示会帮助定位痒痒点',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
