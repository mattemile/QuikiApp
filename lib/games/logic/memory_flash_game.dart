import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Show 6 cards for 2 seconds, then find the matching pair
class MemoryFlashGame extends QuikiBaseGame {
  final List<CardComponent> _cards = [];
  final Random _random = Random();
  bool _canTap = false;
  int _firstSelectedIndex = -1;
  final List<int> _cardValues = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create 3 pairs (6 cards) with random values
    final availableValues = List.generate(9, (i) => i + 1); // 1-9
    availableValues.shuffle(_random);

    // Pick 3 random values and duplicate them to create pairs
    for (int i = 0; i < 3; i++) {
      _cardValues.add(availableValues[i]);
      _cardValues.add(availableValues[i]);
    }
    _cardValues.shuffle(_random);

    // Create cards in 2x3 grid
    final cardWidth = size.x / 3 - 20;
    final cardHeight = size.y / 2 - 40;

    for (int i = 0; i < 6; i++) {
      final row = i ~/ 3;
      final col = i % 3;

      final card = CardComponent(
        position: Vector2(
          col * (cardWidth + 10) + 10,
          row * (cardHeight + 10) + 10,
        ),
        size: Vector2(cardWidth, cardHeight),
        value: _cardValues[i],
        index: i,
        onTap: _onCardTapped,
      );
      _cards.add(card);
      add(card);
    }

    // Show cards for 2 seconds
    for (final card in _cards) {
      card.reveal();
    }

    Future.delayed(const Duration(seconds: 2), () {
      for (final card in _cards) {
        card.hide();
      }
      _canTap = true;
    });
  }

  void _onCardTapped(int index) {
    if (!_canTap || _cards[index].isRevealed) return;

    _cards[index].reveal();

    if (_firstSelectedIndex == -1) {
      _firstSelectedIndex = index;
    } else {
      // Check if match
      if (_cardValues[_firstSelectedIndex] == _cardValues[index]) {
        _canTap = false;
        completeGame(won: true, points: 100);
      } else {
        _canTap = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          _cards[_firstSelectedIndex].hide();
          _cards[index].hide();
          _firstSelectedIndex = -1;
          failGame();
        });
      }
    }
  }
}

class CardComponent extends PositionComponent with TapCallbacks {
  final int value;
  final int index;
  final Function(int) onTap;
  bool isRevealed = false;

  late Paint _cardPaint;
  late Paint _valuePaint;
  late TextPaint _textPaint;

  CardComponent({
    required Vector2 position,
    required Vector2 size,
    required this.value,
    required this.index,
    required this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _cardPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.fill;

    _valuePaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.fill;

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void reveal() {
    isRevealed = true;
  }

  void hide() {
    isRevealed = false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw card background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      isRevealed ? _valuePaint : _cardPaint,
    );

    // Draw value if revealed
    if (isRevealed) {
      _textPaint.render(
        canvas,
        value.toString(),
        Vector2(size.x / 2 - 12, size.y / 2 - 20),
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap(index);
  }
}
