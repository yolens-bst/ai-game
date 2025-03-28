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
        appBar: AppBar(title: Text('gameRules'.tr), centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'gameRulesTitle'.tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('gameRulesContent'.tr, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
