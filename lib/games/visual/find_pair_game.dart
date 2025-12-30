import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Find the two identical symbols among 9
class FindPairGame extends QuikiBaseGame {
  final List<SymbolTile> _tiles = [];
  final Random _random = Random();
  bool _gameActive = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Instructions
    final instructionText = TextComponent(
      text: 'Trova i 2 simboli identici!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Pick 2 identical symbols and 7 different ones
    final symbols = ['●', '■', '▲', '★', '♦', '♥', '♣', '◆', '◊'];
    symbols.shuffle(_random);

    final tileSymbols = <String>[];
    // Add the matching pair
    tileSymbols.add(symbols[0]);
    tileSymbols.add(symbols[0]);
    // Add 7 different symbols
    for (int i = 1; i < 8; i++) {
      tileSymbols.add(symbols[i]);
    }
    tileSymbols.shuffle(_random);

    // Create 3x3 grid
    final tileSize = (size.x - 40) / 3;

    for (int i = 0; i < 9; i++) {
      final row = i ~/ 3;
      final col = i % 3;

      final tile = SymbolTile(
        position: Vector2(
          col * (tileSize + 5) + 10,
          size.y * 0.25 + row * (tileSize + 5),
        ),
        size: Vector2.all(tileSize),
        symbol: tileSymbols[i],
        isPair: tileSymbols[i] == symbols[0],
        onTap: _onTileTapped,
      );
      _tiles.add(tile);
      add(tile);
    }
  }

  void _onTileTapped(bool isPair) {
    if (!_gameActive) return;

    _gameActive = false;
    if (isPair) {
      completeGame(won: true, points: 100);
    } else {
      failGame();
    }
  }
}

class SymbolTile extends PositionComponent with TapCallbacks {
  final String symbol;
  final bool isPair;
  final Function(bool) onTap;
  late Paint _paint;
  late TextPaint _textPaint;

  SymbolTile({
    required Vector2 position,
    required Vector2 size,
    required this.symbol,
    required this.isPair,
    required this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = const Color(0xFF424242)
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

    // Draw tile background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      _paint,
    );

    // Draw symbol centered
    _textPaint.render(
      canvas,
      symbol,
      Vector2(size.x / 2 - 18, size.y / 2 - 24),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap(isPair);
  }
}
