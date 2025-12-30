import 'package:flame/game.dart';

/// Base class for all mini-games
abstract class QuikiBaseGame extends FlameGame {
  Function(bool won, int points)? onGameComplete;

  QuikiBaseGame() : super();

  /// Called when player wins
  void completeGame({bool won = true, int points = 100}) {
    onGameComplete?.call(won, points);
  }

  /// Called when player loses
  void failGame() {
    onGameComplete?.call(false, 0);
  }
}
