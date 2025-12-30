import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../base_game.dart';

/// Find the different symbol among 4 items
class FindIntruderGame extends QuikiBaseGame {
  late int _intruderIndex;
  final List<SymbolComponent> _symbols = [];
  final Random _random = Random();
  bool _gameStarted = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Pick random intruder position
    _intruderIndex = _random.nextInt(4);

    // Create 4 symbols in a grid
    final spacing = size.x / 2;
    final positions = [
      Vector2(spacing * 0.5, spacing * 0.5),
      Vector2(spacing * 1.5, spacing * 0.5),
      Vector2(spacing * 0.5, spacing * 1.5),
      Vector2(spacing * 1.5, spacing * 1.5),
    ];

    for (int i = 0; i < 4; i++) {
      final isIntruder = i == _intruderIndex;
      final symbol = SymbolComponent(
        position: positions[i],
        isIntruder: isIntruder,
        onTap: () => _onSymbolTapped(isIntruder),
      );
      _symbols.add(symbol);
      add(symbol);
    }

    _gameStarted = true;
  }

  void _onSymbolTapped(bool isIntruder) {
    if (!_gameStarted) return;

    _gameStarted = false;
    if (isIntruder) {
      completeGame(won: true, points: 100);
    } else {
      failGame();
    }
  }
}

class SymbolComponent extends PositionComponent with TapCallbacks {
  final bool isIntruder;
  final VoidCallback onTap;
  late Paint _paint;

  SymbolComponent({
    required Vector2 position,
    required this.isIntruder,
    required this.onTap,
  }) : super(position: position, size: Vector2.all(100));

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = isIntruder ? const Color(0xFFFF5252) : const Color(0xFF42A5F5)
      ..style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isIntruder) {
      // Draw square for intruder
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        _paint,
      );
    } else {
      // Draw circle for normal items
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        _paint,
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap();
  }
}
