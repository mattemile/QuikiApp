import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Tocca solo i multipli di 3
class MultiplesGame extends QuikiBaseGame {
  final Random _random = Random();
  int _correctTaps = 0;
  final int _targetTaps = 5;
  bool _gameActive = true;
  late TextComponent _scoreCounter;
  // TODO: forse multipli di 5 sarebbero più facili?

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Istruzioni
    final instructionText = TextComponent(
      text: 'Tocca solo i multipli di 3!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 40),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Contatore
    _scoreCounter = TextComponent(
      text: '0 / 5',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 90),
      anchor: Anchor.center,
    );
    add(_scoreCounter);

    _spawnNumber();
  }

  void _spawnNumber() {
    if (!_gameActive) return;

    // 70% di probabilità di multiplo di 3 - rende più facile vincere
    final isMultiple = _random.nextInt(10) < 7;
    final number = isMultiple
        ? (_random.nextInt(10) + 1) * 3
        : _random.nextInt(30) + 1;

    // Salta i multipli effettivi di 3 se vogliamo un non-multiplo
    final actualNumber = !isMultiple && number % 3 == 0 ? number + 1 : number;

    final numberBubble = NumberBubble(
      position: Vector2(size.x / 2, size.y / 2),
      number: actualNumber,
      isMultiple: actualNumber % 3 == 0,
      onTap: _onNumberTapped,
      onTimeout: _onNumberTimeout,
    );

    add(numberBubble);
  }

  void _onNumberTapped(bool isMultiple) {
    if (!_gameActive) return;

    if (isMultiple) {
      _correctTaps++;
      _scoreCounter.text = '$_correctTaps / 5';

      if (_correctTaps >= _targetTaps) {
        _gameActive = false;
        completeGame(won: true, points: 100);
      } else {
        _spawnNumber();
      }
    } else {
      // Toccato un non-multiplo - è un fallimento
      _gameActive = false;
      failGame();
    }
  }

  void _onNumberTimeout(bool isMultiple) {
    if (!_gameActive) return;

    // Timeout OK se non era un multiplo, fail se lo era
    if (isMultiple) {
      _gameActive = false;
      failGame();
    } else {
      _spawnNumber();
    }
  }
}

class NumberBubble extends CircleComponent with TapCallbacks {
  final int number;
  final bool isMultiple;
  final Function(bool) onTap;
  final Function(bool) onTimeout;
  late TextPaint _textPaint;
  late TimerComponent _timer;
  bool _tapped = false;

  NumberBubble({
    required Vector2 position,
    required this.number,
    required this.isMultiple,
    required this.onTap,
    required this.onTimeout,
  }) : super(
          radius: 60,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF5C6BC0),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );

    // Timeout 1.5 secondi
    _timer = TimerComponent(
      period: 1.5,
      repeat: false,
      onTick: () {
        if (!_tapped) {
          onTimeout(isMultiple);
        }
        removeFromParent();
      },
    );
    add(_timer);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textOffset = number >= 10 ? -20.0 : -12.0;
    _textPaint.render(
      canvas,
      number.toString(),
      Vector2(textOffset, -18),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!_tapped) {
      _tapped = true;
      removeFromParent();
      onTap(isMultiple);
    }
  }
}
