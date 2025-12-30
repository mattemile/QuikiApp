import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Find the slightly different color shade among squares
class ColorDiffGame extends QuikiBaseGame {
  late int _differentIndex;
  final List<ColorSquare> _squares = [];
  final Random _random = Random();
  bool _gameActive = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _differentIndex = _random.nextInt(16);

    // Base color
    final baseHue = _random.nextDouble() * 360;
    final baseSat = 0.7;
    final baseVal = 0.9;

    // Create 4x4 grid
    final squareSize = size.x / 4 - 10;

    for (int i = 0; i < 16; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final isDifferent = i == _differentIndex;
      // Make the different one slightly lighter
      final val = isDifferent ? baseVal - 0.15 : baseVal;

      final square = ColorSquare(
        position: Vector2(
          col * (squareSize + 5) + 5,
          row * (squareSize + 5) + 5,
        ),
        size: Vector2.all(squareSize),
        color: HSVColor.fromAHSV(1.0, baseHue, baseSat, val).toColor(),
        isDifferent: isDifferent,
        onTap: _onSquareTapped,
      );

      _squares.add(square);
      add(square);
    }
  }

  void _onSquareTapped(bool isDifferent) {
    if (!_gameActive) return;
    _gameActive = false;

    if (isDifferent) {
      completeGame(won: true, points: 100);
    } else {
      failGame();
    }
  }
}

class ColorSquare extends PositionComponent with TapCallbacks {
  final Color color;
  final bool isDifferent;
  final Function(bool) onTap;
  late Paint _paint;

  ColorSquare({
    required Vector2 position,
    required Vector2 size,
    required this.color,
    required this.isDifferent,
    required this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      _paint,
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap(isDifferent);
  }
}
