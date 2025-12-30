import 'package:flame/game.dart';

/// Configuration for a mini-game
class GameConfig {
  final String id;
  final String name;
  final String description;
  final GameCategory category;
  final FlameGame Function() gameBuilder;
  final int maxDuration; // seconds

  GameConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.gameBuilder,
    this.maxDuration = 60,
  });
}

/// Game categories
enum GameCategory {
  logic,
  visual,
  reflex,
  math,
  creativity,
  precision,
}

extension GameCategoryExtension on GameCategory {
  String get displayName {
    switch (this) {
      case GameCategory.logic:
        return 'Logica';
      case GameCategory.visual:
        return 'Abilità visiva';
      case GameCategory.reflex:
        return 'Riflessi';
      case GameCategory.math:
        return 'Numeri';
      case GameCategory.creativity:
        return 'Creatività';
      case GameCategory.precision:
        return 'Precisione';
    }
  }
}
