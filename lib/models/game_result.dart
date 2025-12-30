/// Result of a game session
class GameResult {
  final String gameId;
  final bool won;
  final int score;
  final DateTime playedAt;
  final int durationSeconds;

  GameResult({
    required this.gameId,
    required this.won,
    required this.score,
    required this.playedAt,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'won': won,
      'score': score,
      'playedAt': playedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      gameId: json['gameId'],
      won: json['won'],
      score: json['score'],
      playedAt: DateTime.parse(json['playedAt']),
      durationSeconds: json['durationSeconds'],
    );
  }
}
