import '../models/game_settings.dart';

class GameResult {
  final int totalScore;
  int get score => totalScore;
  final double fastestResponse;
  final double slowestResponse;
  final double averageResponse;
  final bool isSuccess;
  final int correctTaps;
  final int wrongTaps;
  final double accuracy;
  final int preciseHits;
  final int totalTaps;
  final GameSettings settings;
  final DateTime timestamp;

  GameResult({
    required this.totalScore,
    required this.fastestResponse,
    required this.slowestResponse,
    required this.averageResponse,
    required this.isSuccess,
    required this.correctTaps,
    required this.wrongTaps,
    required this.accuracy,
    required this.preciseHits,
    required this.settings,
    DateTime? timestamp,
  }) : totalTaps = correctTaps + wrongTaps,
       timestamp = timestamp ?? DateTime.now();

  String get resultText => isSuccess ? '挑战成功!' : '挑战失败';

  Map<String, dynamic> toJson() => {
    'totalScore': totalScore,
    'fastestResponse': fastestResponse,
    'slowestResponse': slowestResponse,
    'averageResponse': averageResponse,
    'isSuccess': isSuccess,
    'correctTaps': correctTaps,
    'wrongTaps': wrongTaps,
    'accuracy': accuracy,
    'preciseHits': preciseHits,
    'settings': settings.toJson(),
    'timestamp': timestamp.toIso8601String(),
  };

  factory GameResult.fromJson(Map<String, dynamic> json) => GameResult(
    totalScore: json['totalScore'],
    correctTaps: json['correctTaps'],
    wrongTaps: json['wrongTaps'],
    accuracy: json['accuracy'],
    fastestResponse: json['fastestResponse'],
    slowestResponse: json['slowestResponse'],
    averageResponse: json['averageResponse'],
    isSuccess: json['isSuccess'],
    preciseHits: json['preciseHits'],
    settings: GameSettings.fromJson(json['settings']),
    timestamp: DateTime.parse(json['timestamp']),
  );
}
