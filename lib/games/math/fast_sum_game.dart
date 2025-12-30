import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Solve simple math additions quickly
class FastSumGame extends QuikiBaseGame {
  final Random _random = Random();
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  late List<int> _answers;
  bool _gameActive = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Generate simple addition
    _num1 = _random.nextInt(20) + 1;
    _num2 = _random.nextInt(20) + 1;
    _correctAnswer = _num1 + _num2;

    // Generate 4 answer options (including correct one)
    _answers = [_correctAnswer];
    while (_answers.length < 4) {
      final wrongAnswer = _correctAnswer + _random.nextInt(10) - 5;
      if (wrongAnswer > 0 && !_answers.contains(wrongAnswer)) {
        _answers.add(wrongAnswer);
      }
    }
    _answers.shuffle(_random);

    // Display question
    final questionText = TextComponent(
      text: '$_num1 + $_num2 = ?',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.3),
      anchor: Anchor.center,
    );
    add(questionText);

    // Display answer buttons
    final buttonWidth = size.x / 2 - 20;
    final buttonHeight = 80.0;

    for (int i = 0; i < 4; i++) {
      final row = i ~/ 2;
      final col = i % 2;

      final button = AnswerButton(
        position: Vector2(
          col * (buttonWidth + 10) + 10,
          size.y * 0.5 + row * (buttonHeight + 10),
        ),
        size: Vector2(buttonWidth, buttonHeight),
        answer: _answers[i],
        isCorrect: _answers[i] == _correctAnswer,
        onTap: _onAnswerTapped,
      );
      add(button);
    }
  }

  void _onAnswerTapped(bool isCorrect) {
    if (!_gameActive) return;
    _gameActive = false;

    if (isCorrect) {
      completeGame(won: true, points: 100);
    } else {
      failGame();
    }
  }
}

class AnswerButton extends PositionComponent with TapCallbacks {
  final int answer;
  final bool isCorrect;
  final Function(bool) onTap;
  late Paint _paint;
  late TextPaint _textPaint;

  AnswerButton({
    required Vector2 position,
    required Vector2 size,
    required this.answer,
    required this.isCorrect,
    required this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = const Color(0xFF26A69A)
      ..style = PaintingStyle.fill;

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      _paint,
    );

    _textPaint.render(
      canvas,
      answer.toString(),
      Vector2(size.x / 2 - 15, size.y / 2 - 18),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap(isCorrect);
  }
}
