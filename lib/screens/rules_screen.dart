import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/sound_manager.dart';
import '../models/game_settings.dart';
import '../languages/translations.dart';

class RulesScreen extends StatelessWidget {
  final GameSettings settings;

  const RulesScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => SoundManager().playClick(),
      child: Scaffold(
        appBar: AppBar(title: Text('gameRules'.tr), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('gameObjective'.tr),
              _buildRuleItem(Icons.flag, 'gameObjectiveDesc'.tr),

              _buildSectionTitle('gameModes'.tr),
              _buildRuleItem(Icons.timer, 'normalModeDesc'.tr),
              _buildRuleItem(Icons.all_inclusive, 'endlessModeDesc'.tr),

              _buildSectionTitle('scoringRules'.tr),
              _buildRuleItem(Icons.star, 'baseScoreDesc'.tr),
              _buildRuleItem(Icons.zoom_in, 'precisionBonusDesc'.tr),
              _buildRuleItem(Icons.multiline_chart, 'comboSystemDesc'.tr),

              _buildSectionTitle('difficultyLevels'.tr),
              _buildRuleItem(Icons.speed, 'easyModeDesc'.tr),
              _buildRuleItem(Icons.speed, 'mediumModeDesc'.tr),
              _buildRuleItem(Icons.speed, 'hardModeDesc'.tr),

              _buildSectionTitle('specialEffects'.tr),
              _buildRuleItem(Icons.accessibility, 'characterSwingDesc'.tr),
              _buildRuleItem(Icons.help_outline, 'hintSystemDesc'.tr),
              _buildRuleItem(Icons.vibration, 'vibrationFeedbackDesc'.tr),

              const SizedBox(height: 20),
              Text(
                'enjoyGameText'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
