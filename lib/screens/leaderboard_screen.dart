import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';
import '../controllers/leaderboard_controller.dart';
import '../languages/translations.dart';

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
        appBar: AppBar(title: Text('leaderboard'.tr), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                return SegmentedButton(
                  segments: [
                    ButtonSegment(
                      value: DifficultyLevel.easy,
                      label: Text('easy'.tr),
                    ),
                    ButtonSegment(
                      value: DifficultyLevel.medium,
                      label: Text('medium'.tr),
                    ),
                    ButtonSegment(
                      value: DifficultyLevel.hard,
                      label: Text('hard'.tr),
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
                            'noLeaderboardData'.tr,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              SoundManager().playClick();
                              Get.back();
                            },
                            child: Text('goChallenge'.tr),
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
                              '${'playerName'.tr}:${results[index].settings.playerName}',
                            ),
                            subtitle: Text(
                              '${'difficultyLevel'.tr}: ${results[index].settings.difficulty.label.tr}',
                            ),
                            trailing: Text(
                              'scorePoints'.trParams({
                                'points': '${results[index].score}',
                              }),
                            ),
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
