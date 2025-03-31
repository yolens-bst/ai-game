import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/game_result.dart';
import '../models/game_settings.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController get to => Get.find();
  final leaderboard = <GameResult>[].obs;
  late SharedPreferences _prefs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _loadLeaderboard();
  }

  void _loadLeaderboard() {
    final jsonString = _prefs.getString('leaderboard');
    if (jsonString != null) {
      try {
        final saved = json.decode(jsonString) as List;
        leaderboard.value =
            saved
                .map((json) => GameResult.fromJson(json))
                .toList()
                .cast<GameResult>();
      } catch (e) {
        print('Error loading leaderboard: $e');
      }
    }
  }

  void _saveLeaderboard() {
    _prefs.setString(
      'leaderboard',
      json.encode(leaderboard.map((result) => result.toJson()).toList()),
    );
  }

  void addGameResult(GameResult result) {
    leaderboard.add(GameResult.fromJson(result.toJson()));
    // 按分数降序排序
    leaderboard.sort((a, b) => b.score.compareTo(a.score));
    // 只保留前100条记录
    if (leaderboard.length > 100) {
      leaderboard.removeRange(100, leaderboard.length);
    }
    _saveLeaderboard();
  }

  List<GameResult> getResultsByDifficulty(DifficultyLevel difficulty) {
    return leaderboard
        .where((result) => result.settings.difficulty == difficulty)
        .toList();
  }
}
