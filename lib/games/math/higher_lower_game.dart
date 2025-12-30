import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Tocca il numero più alto tra due
class HigherLowerGame extends QuikiBaseGame {
  final Random _random = Random();
  int _correctTaps = 0;
  final int _targetTaps = 8;
  bool _gameActive = true;

  late TextComponent _scoreCounter;
  // potrei ridurre a 6 round invece di 8? da testare

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Istruzioni
    final instructionText = TextComponent(
      text: 'Tocca il numero\nMAGGIORE!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 60),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Contatore
    _scoreCounter = TextComponent(
      text: '0 / 8',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 110),
      anchor: Anchor.center,
    );
    add(_scoreCounter);

    _spawnNumbers();
  }

  void _spawnNumbers() {
    // Non generare se il gioco non è attivo
    if (!_gameActive) return;

    // Genera due numeri casuali diversi
    final num1 = _random.nextInt(99) + 1; // 1-99
    int num2;
    do {
      num2 = _random.nextInt(99) + 1;
    } while (num1 == num2);

    final isLeftHigher = num1 > num2;

    // Left number
    final leftButton = NumberChoice(
      position: Vector2(size.x * 0.25, size.y / 2),
      number: num1,
      isHigher: isLeftHigher,
      onTap: _onNumberTapped,
    );
    add(leftButton);

    // Right number
    final rightButton = NumberChoice(
      position: Vector2(size.x * 0.75, size.y / 2),
      number: num2,
      isHigher: !isLeftHigher,
      onTap: _onNumberTapped,
    );
    add(rightButton);

    // VS text
    final vsText = TextComponent(
      text: 'VS',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
    add(vsText);
  }

  void _onNumberTapped(bool isHigher) {
    if (!_gameActive) return;

    if (isHigher) {
      _correctTaps++;
      _scoreCounter.text = '$_correctTaps / 8';

      // Rimuovi i numeri correnti (toList() evita modifica concorrente)
      children.whereType<NumberChoice>().toList().forEach((c) => c.removeFromParent());
      children.whereType<TextComponent>().where((c) => c.text == 'VS').toList().forEach((c) => c.removeFromParent());

      if (_correctTaps >= _targetTaps) {
        _gameActive = false;
        completeGame(won: true, points: 100);
      } else {
        // Genera la prossima coppia dopo un breve delay
        Future.delayed(const Duration(milliseconds: 300), _spawnNumbers);
      }
    } else {
      _gameActive = false;
      failGame();
    }
  }
}

class NumberChoice extends PositionComponent with TapCallbacks {
  final int number;
  final bool isHigher;
  final Function(bool) onTap;
  late Paint _paint;
  late TextPaint _textPaint;

  NumberChoice({
    required Vector2 position,
    required this.number,
    required this.isHigher,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2.all(100),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = const Color(0xFF3F51B5)
      ..style = PaintingStyle.fill;

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 48,
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
      _paint,
    );

    // Draw number
    final textOffset = number >= 10 ? -28.0 : -18.0;
    _textPaint.render(
      canvas,
      number.toString(),
      Vector2(size.x / 2 + textOffset, size.y / 2 - 24),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap(isHigher);
  }
}
