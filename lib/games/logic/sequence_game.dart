import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Tap numbers in ascending order
class SequenceGame extends QuikiBaseGame {
  final List<NumberButton> _buttons = [];
  final Random _random = Random();
  int _nextNumberToTap = 1;
  final int _totalNumbers = 8;
  bool _gameActive = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Instructions
    final instructionText = TextComponent(
      text: 'Tocca i numeri in ordine\ncrescente!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 40),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Generate random positions for numbers 1-8
    final positions = <Vector2>[];
    final gridSize = 3;
    final spacing = size.x / (gridSize + 1);

    // Create a grid of possible positions
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (positions.length < _totalNumbers) {
          positions.add(Vector2(
            spacing * (col + 1),
            size.y * 0.3 + spacing * row,
          ));
        }
      }
    }

    // Shuffle positions
    positions.shuffle(_random);

    // Create buttons with numbers 1-8
    for (int i = 0; i < _totalNumbers; i++) {
      final button = NumberButton(
        position: positions[i],
        number: i + 1,
        onTap: _onNumberTapped,
      );
      _buttons.add(button);
      add(button);
    }
  }

  void _onNumberTapped(int number) {
    if (!_gameActive) return;

    if (number == _nextNumberToTap) {
      // Correct number
      _nextNumberToTap++;

      // Check if all numbers tapped
      if (_nextNumberToTap > _totalNumbers) {
        _gameActive = false;
        completeGame(won: true, points: 100);
      }
    } else {
      // Wrong number
      _gameActive = false;
      failGame();
    }
  }
}

class NumberButton extends PositionComponent with TapCallbacks {
  final int number;
  final Function(int) onTap;
  bool _tapped = false;
  late Paint _paint;
  late Paint _tappedPaint;
  late TextPaint _textPaint;

  NumberButton({
    required Vector2 position,
    required this.number,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2.all(60),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    _tappedPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw circle
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      _tapped ? _tappedPaint : _paint,
    );

    // Draw number
    final textOffset = number >= 10 ? -18.0 : -12.0;
    _textPaint.render(
      canvas,
      number.toString(),
      Vector2(size.x / 2 + textOffset, size.y / 2 - 16),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!_tapped) {
      _tapped = true;
      onTap(number);
    }
  }
}
