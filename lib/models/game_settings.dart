enum DifficultyLevel {
  easy(1, 'easy'),
  medium(2, 'medium'),
  hard(3, 'hard');

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
  String language;

  GameSettings({
    this.difficulty = DifficultyLevel.medium,
    this.duration = 20,
    this.enableSwing = true,
    this.enableHints = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.playerName = 'Player',
    this.language = 'zh_CN',
  });

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      difficulty: DifficultyLevel.fromValue(json['difficulty'] ?? 1),
      duration: json['duration'] ?? 20,
      enableSwing: json['enableSwing'] ?? true,
      enableHints: json['enableHints'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      playerName: json['playerName'] ?? 'Player',
      language: json['language'] ?? 'zh_CN',
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
      'language': language,
    };
  }
}
