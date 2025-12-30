import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../base_game.dart';

/// Tap when the circle turns green
class TapGreenGame extends QuikiBaseGame with TapCallbacks {
  late TimerComponent _colorTimer;
  late CircleComponent _circle;
  bool _isGreen = false;
  bool _canTap = false;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add circle in center
    _circle = CircleComponent(
      radius: 80,
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFFE57373), // Red initially
    );
    add(_circle);

    // Wait random time (1-3 seconds) then turn green
    final waitTime = 1.0 + _random.nextDouble() * 2.0;

    _colorTimer = TimerComponent(
      period: waitTime,
      repeat: false,
      onTick: () {
        _isGreen = true;
        _canTap = true;
        _circle.paint.color = const Color(0xFF66BB6A); // Green
      },
    );
    add(_colorTimer);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!_canTap) {
      // Tapped too early
      failGame();
      return;
    }

    if (_isGreen) {
      completeGame(won: true, points: 100);
    } else {
      failGame();
    }
  }
}
