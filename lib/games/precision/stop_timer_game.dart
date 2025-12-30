import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Stop the timer exactly at 10.00 seconds
class StopTimerGame extends QuikiBaseGame with TapCallbacks {
  late TextComponent _timerText;
  double _elapsedTime = 0;
  bool _running = true;
  bool _stopped = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Instructions
    final instructionText = TextComponent(
      text: 'Ferma il timer a 10.00!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.3),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Timer display
    _timerText = TextComponent(
      text: '0.00',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF4FC3F7),
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
    add(_timerText);

    // Tap instruction
    final tapText = TextComponent(
      text: 'Tocca per fermare',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 18,
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.7),
      anchor: Anchor.center,
    );
    add(tapText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_running) {
      _elapsedTime += dt;
      _timerText.text = _elapsedTime.toStringAsFixed(2);

      // Auto-fail if over 11 seconds
      if (_elapsedTime > 11.0) {
        _running = false;
        failGame();
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_stopped) return;

    _stopped = true;
    _running = false;

    // Check if close to 10.00 (within 0.15 seconds tolerance)
    final difference = (_elapsedTime - 10.0).abs();

    if (difference < 0.15) {
      // Perfect or very close
      final points = (100 - (difference * 200)).round();
      completeGame(won: true, points: points.clamp(80, 100));
    } else {
      failGame();
    }
  }
}
