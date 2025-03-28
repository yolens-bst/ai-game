import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  final GameSettings settings;
  final LeaderboardController controller = LeaderboardController.to;
  final Rx<DifficultyLevel> diff = DifficultyLevel.medium.obs;

  LeaderboardScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => SoundManager().playClick(),
      child: Scaffold(
        appBar: AppBar(title: Text('排行榜'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                return SegmentedButton(
                  segments: [
                    ButtonSegment(
                      value: DifficultyLevel.easy,
                      label: Text('简单'),
                    ),
                    ButtonSegment(
                      value: DifficultyLevel.medium,
                      label: Text('中等'),
                    ),
                    ButtonSegment(
                      value: DifficultyLevel.hard,
                      label: Text('困难'),
                    ),
                  ],
                  selected: {diff.value},
                  onSelectionChanged: (newSelection) {
                    diff.value = newSelection.first;
                  },
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                final results = controller.getResultsByDifficulty(diff.value);
                return results.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lotties/loser.json', width: 150),
                          SizedBox(height: 16),
                          Text(
                            '暂无排行榜数据',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              SoundManager().playClick();
                              Get.back();
                            },
                            child: Text('去挑战'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: results.length,
                      itemBuilder:
                          (context, index) => ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(
                              '玩家: ${results[index].settings.playerName}',
                            ),
                            subtitle: Text(
                              '难度: ${results[index].settings.difficulty.label}',
                            ),
                            trailing: Text('${results[index].score} 分'),
                          ),
                    );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
