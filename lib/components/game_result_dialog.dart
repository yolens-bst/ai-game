import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
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
                _buildStatItem('scoreLabel'.tr, '${widget.result.totalScore}'),
                _buildStatItem(
                  'difficultyLabel'.tr,
                  _getDifficultyText(widget.result.settings.difficulty),
                ),
                _buildStatItem(
                  'correctTapsLabel'.tr,
                  '${widget.result.correctTaps}',
                ),
                _buildStatItem(
                  'wrongTapsLabel'.tr,
                  '${widget.result.wrongTaps}',
                ),
                _buildStatItem(
                  'accuracyLabel'.tr,
                  '${(widget.result.accuracy * 100).toStringAsFixed(2)}%',
                ),
                _buildStatItem(
                  'preciseHitsLabel'.tr,
                  '${widget.result.preciseHits}',
                ),
                _buildStatItem(
                  'fastestResponseLabel'.tr,
                  '${widget.result.fastestResponse.toStringAsFixed(4)}s',
                ),
                _buildStatItem(
                  'slowestResponseLabel'.tr,
                  '${widget.result.slowestResponse.toStringAsFixed(4)}s',
                ),
                _buildStatItem(
                  'averageResponseLabel'.tr,
                  '${widget.result.averageResponse.toStringAsFixed(4)}s',
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
                      label: Text('restartButton'.tr),
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
                      label: Text('homeButton'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            child: SizedBox(
              // width: 200,
              height: 200,
              child: Lottie.asset(
                widget.result.isSuccess
                    ? 'assets/lotties/victory.json'
                    : 'assets/lotties/loser1.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'easy'.tr;
      case DifficultyLevel.medium:
        return 'medium'.tr;
      case DifficultyLevel.hard:
        return 'hard'.tr;
      default:
        return 'unknown'.tr;
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
