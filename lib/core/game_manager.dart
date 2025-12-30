import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_config.dart';
import '../models/game_result.dart';
import 'storage.dart';

/// Gestore principale del gioco - gestisce selezione giochi, vite, punteggi
class GameManager extends ChangeNotifier {
  final GameStorage storage;
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Stato del gioco
  int _lives = 3;
  int _currentScore = 0;
  int _streak = 0;
  List<GameConfig> _availableGames = [];
  GameConfig? _currentGame;
  DateTime? _gameStartTime;

  GameManager({required this.storage});

  // Getters
  int get lives => _lives;
  int get currentScore => _currentScore;
  int get streak => _streak;
  GameConfig? get currentGame => _currentGame;
  List<GameConfig> get availableGames => _availableGames;

  /// Registra tutti i giochi disponibili
  void registerGames(List<GameConfig> games) {
    _availableGames = games;
    notifyListeners();
  }

  /// Inizia una nuova sessione di gioco
  void startNewSession() {
    _lives = 3;
    _currentScore = 0;
    _streak = 0;
    _gameStartTime = null;
    _currentGame = null;
    storage.setCurrentStreak(0);
    notifyListeners();
  }

  /// Seleziona un gioco casuale tra quelli disponibili
  GameConfig? pickRandomGame() {
    if (_availableGames.isEmpty) return null;

    final game = _availableGames[_random.nextInt(_availableGames.length)];
    _currentGame = game;
    _gameStartTime = DateTime.now();
    notifyListeners();
    return game;
  }

  /// Gestisce la vittoria di un gioco
  Future<void> onGameWon(int points) async {
    _currentScore += points;
    _streak++;
    await storage.setCurrentStreak(_streak);

    // Feedback tattile per successo
    await HapticFeedback.mediumImpact();

    notifyListeners();
  }

  /// Gestisce la sconfitta di un gioco
  Future<void> onGameLost() async {
    _lives--;
    _streak = 0;
    await storage.setCurrentStreak(0);

    // Vibrazione leggera per fallimento
    await HapticFeedback.lightImpact();

    notifyListeners();

    // Controlla se game over
    if (_lives <= 0) {
      await _endSession(won: false);
    }
  }

  /// Termina la sessione corrente
  Future<void> _endSession({required bool won}) async {
    if (_currentGame == null || _gameStartTime == null) return;

    final duration = DateTime.now().difference(_gameStartTime!).inSeconds;
    final result = GameResult(
      gameId: _currentGame!.id,
      won: won,
      score: _currentScore,
      playedAt: DateTime.now(),
      durationSeconds: duration,
    );

    await storage.saveResult(result);
    notifyListeners();
  }

  /// Controlla se la sessione è terminata
  bool get isGameOver => _lives <= 0;

  /// Riproduci suono di successo
  Future<void> playSuccessSound() async {
    // Si potrebbero aggiungere effetti sonori qui
    await HapticFeedback.mediumImpact();
  }

  /// Riproduci suono di fallimento
  Future<void> playFailureSound() async {
    // Si potrebbero aggiungere effetti sonori qui
    await HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
