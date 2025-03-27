class GameResult {
  final int totalScore;
  final double fastestResponse;
  final double slowestResponse;
  final double averageResponse;
  final bool isSuccess;
  final int correctTaps;
  final int wrongTaps;
  final double accuracy;
  final int preciseHits;
  final int totalTaps;

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
  }) : totalTaps = correctTaps + wrongTaps;

  String get resultText => isSuccess ? '挑战成功!' : '挑战失败';
}
