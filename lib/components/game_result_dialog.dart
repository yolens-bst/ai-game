import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/game_result.dart';
import '../models/game_settings.dart';
import '../game/sound_manager.dart';

class GameResultDialog extends StatefulWidget {
  final GameResult result;

  const GameResultDialog({super.key, required this.result});

  @override
  State<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends State<GameResultDialog> {
  @override
  void initState() {
    super.initState();
    if (widget.result.isSuccess) {
      SoundManager().playVictory();
    } else {
      SoundManager().playDefeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.result.resultText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.result.isSuccess ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatItem('总得分', '${widget.result.totalScore}分'),
            _buildStatItem(
              '难度级别',
              _getDifficultyText(widget.result.settings.difficulty),
            ),
            _buildStatItem('正确点击', '${widget.result.correctTaps}次'),
            _buildStatItem('错误点击', '${widget.result.wrongTaps}次'),
            _buildStatItem(
              '准确率',
              '${(widget.result.accuracy * 100).toStringAsFixed(2)}%',
            ),
            _buildStatItem('精准点击', '${widget.result.preciseHits}次'),
            _buildStatItem(
              '最快反应',
              '${widget.result.fastestResponse.toStringAsFixed(4)}秒',
            ),
            _buildStatItem(
              '最慢反应',
              '${widget.result.slowestResponse.toStringAsFixed(4)}秒',
            ),
            _buildStatItem(
              '平均反应',
              '${widget.result.averageResponse.toStringAsFixed(4)}秒',
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    SoundManager().playClick();
                    Get.back(result: 'restart');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('再来一次'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    SoundManager().playClick();
                    Get.back(result: 'home');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('回到首页'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return '简单';
      case DifficultyLevel.medium:
        return '中等';
      case DifficultyLevel.hard:
        return '困难';
      default:
        return '未知';
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
