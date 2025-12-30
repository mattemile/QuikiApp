import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Stop the moving bar exactly on the target
class PreciseStopGame extends QuikiBaseGame with TapCallbacks {
  late RectangleComponent _bar;
  late RectangleComponent _target;
  double _barPosition = 0;
  double _barSpeed = 150; // pixels per second
  bool _movingRight = true;
  bool _stopped = false;
  bool _gameActive = true;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Instructions
    final instructionText = TextComponent(
      text: 'Ferma la barra\nsulla zona verde!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 80),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Random target position
    final targetWidth = 60.0;
    final maxTargetX = size.x - targetWidth - 40;
    final targetX = 20 + _random.nextDouble() * maxTargetX;

    // Target zone (green)
    _target = RectangleComponent(
      position: Vector2(targetX, size.y / 2 - 30),
      size: Vector2(targetWidth, 60),
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    add(_target);

    // Moving bar (blue)
    _bar = RectangleComponent(
      position: Vector2(20, size.y / 2 - 30),
      size: Vector2(40, 60),
      paint: Paint()..color = const Color(0xFF2196F3),
    );
    add(_bar);

    // Track background
    final track = RectangleComponent(
      position: Vector2(20, size.y / 2 - 35),
      size: Vector2(size.x - 40, 70),
      paint: Paint()
        ..color = const Color(0xFF424242)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(track);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_stopped) return;

    // Move bar
    if (_movingRight) {
      _barPosition += _barSpeed * dt;
      if (_barPosition >= size.x - 60) {
        _barPosition = size.x - 60;
        _movingRight = false;
      }
    } else {
      _barPosition -= _barSpeed * dt;
      if (_barPosition <= 0) {
        _barPosition = 0;
        _movingRight = true;
      }
    }

    _bar.position.x = 20 + _barPosition;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_stopped || !_gameActive) return;

    _stopped = true;

    // Check if bar is on target
    final barCenter = _bar.position.x + _bar.size.x / 2;
    final targetLeft = _target.position.x;
    final targetRight = _target.position.x + _target.size.x;

    _gameActive = false;

    if (barCenter >= targetLeft && barCenter <= targetRight) {
      // Calculate accuracy for points
      final targetCenter = _target.position.x + _target.size.x / 2;
      final distance = (barCenter - targetCenter).abs();
      final maxDistance = _target.size.x / 2;
      final accuracy = 1 - (distance / maxDistance);
      final points = (80 + (accuracy * 20)).round();

      completeGame(won: true, points: points.clamp(80, 100));
    } else {
      failGame();
    }
  }
}
