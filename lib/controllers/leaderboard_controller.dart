import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/game_result.dart';
import '../models/game_settings.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController get to => Get.find();
  final _storage = GetStorage('leaderboard');
  final leaderboard = <GameResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLeaderboard();
  }

  void _loadLeaderboard() {
    final saved = _storage.read<List>('leaderboard');
    if (saved != null) {
      leaderboard.value =
          saved
              .map((json) => GameResult.fromJson(json))
              .toList()
              .cast<GameResult>();
    }
  }

  void _saveLeaderboard() {
    _storage.write(
      'leaderboard',
      leaderboard.map((result) => result.toJson()).toList(),
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
