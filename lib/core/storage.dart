import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_result.dart';

/// Local storage manager for game data
class GameStorage {
  static const String _keyHighScore = 'high_score';
  static const String _keyTotalGamesPlayed = 'total_games_played';
  static const String _keyRecentResults = 'recent_results';
  static const String _keyBestStreak = 'best_streak';
  static const String _keyCurrentStreak = 'current_streak';

  final SharedPreferences _prefs;

  GameStorage(this._prefs);

  static Future<GameStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return GameStorage(prefs);
  }

  // High score
  int getHighScore() {
    return _prefs.getInt(_keyHighScore) ?? 0;
  }

  Future<void> setHighScore(int score) async {
    if (score > getHighScore()) {
      await _prefs.setInt(_keyHighScore, score);
    }
  }

  // Total games played
  int getTotalGamesPlayed() {
    return _prefs.getInt(_keyTotalGamesPlayed) ?? 0;
  }

  Future<void> incrementGamesPlayed() async {
    final current = getTotalGamesPlayed();
    await _prefs.setInt(_keyTotalGamesPlayed, current + 1);
  }

  // Current streak
  int getCurrentStreak() {
    return _prefs.getInt(_keyCurrentStreak) ?? 0;
  }

  Future<void> setCurrentStreak(int streak) async {
    await _prefs.setInt(_keyCurrentStreak, streak);

    // Update best streak if current is higher
    final bestStreak = getBestStreak();
    if (streak > bestStreak) {
      await _prefs.setInt(_keyBestStreak, streak);
    }
  }

  // Best streak
  int getBestStreak() {
    return _prefs.getInt(_keyBestStreak) ?? 0;
  }

  // Recent results
  List<GameResult> getRecentResults({int limit = 10}) {
    final jsonList = _prefs.getStringList(_keyRecentResults) ?? [];
    return jsonList
        .map((json) => GameResult.fromJson(jsonDecode(json)))
        .take(limit)
        .toList();
  }

  Future<void> saveResult(GameResult result) async {
    final jsonList = _prefs.getStringList(_keyRecentResults) ?? [];
    jsonList.insert(0, jsonEncode(result.toJson()));

    // Keep only last 50 results
    if (jsonList.length > 50) {
      jsonList.removeRange(50, jsonList.length);
    }

    await _prefs.setStringList(_keyRecentResults, jsonList);
    await incrementGamesPlayed();
    await setHighScore(result.score);
  }

  // Reset all data
  Future<void> resetAll() async {
    await _prefs.clear();
  }
}
