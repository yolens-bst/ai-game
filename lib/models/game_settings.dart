enum DifficultyLevel {
  easy(1, '简单'),
  medium(2, '中等'),
  hard(3, '困难');

  final int value;
  final String label;

  const DifficultyLevel(this.value, this.label);

  static DifficultyLevel fromValue(int value) {
    return values.firstWhere((e) => e.value == value, orElse: () => easy);
  }
}

class GameSettings {
  DifficultyLevel difficulty;
  double duration;
  bool enableSwing;
  bool enableHints;
  bool soundEnabled;
  bool vibrationEnabled;
  String playerName;

  GameSettings({
    this.difficulty = DifficultyLevel.medium,
    this.duration = 20,
    this.enableSwing = true,
    this.enableHints = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.playerName = '玩家',
  });

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      difficulty: DifficultyLevel.fromValue(json['difficulty'] ?? 1),
      duration: json['duration'] ?? 20,
      enableSwing: json['enableSwing'] ?? true,
      enableHints: json['enableHints'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      playerName: json['playerName'] ?? '玩家',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'difficulty': difficulty.value,
      'duration': duration,
      'enableSwing': enableSwing,
      'enableHints': enableHints,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'playerName': playerName,
    };
  }
}
