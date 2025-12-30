import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Tocca i cerchi prima che spariscano
class TapEscapeGame extends QuikiBaseGame {
  final Random _random = Random();
  int _tappedCount = 0;
  final int _targetCount = 5;
  bool _gameActive = true;
  late TextComponent _scoreCounter;
  // TODO: variare colore dei cerchi per renderlo più accattivante

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Contatore punteggio
    _scoreCounter = TextComponent(
      text: '0 / 5',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 60),
      anchor: Anchor.center,
    );
    add(_scoreCounter);

    _spawnCircle();
  }

  void _spawnCircle() {
    if (!_gameActive) return;

    final circle = DisappearingCircle(
      position: Vector2(
        _random.nextDouble() * (size.x - 100) + 50,
        _random.nextDouble() * (size.y - 100) + 50,
      ),
      onTapped: _onCircleTapped,
      onMissed: _onCircleMissed,
    );

    add(circle);
  }

  void _onCircleTapped() {
    _tappedCount++;
    _scoreCounter.text = '$_tappedCount / 5';

    if (_tappedCount >= _targetCount) {
      _gameActive = false;
      completeGame(won: true, points: 100);
    } else {
      // Genera il prossimo cerchio
      Future.delayed(const Duration(milliseconds: 300), _spawnCircle);
    }
  }

  void _onCircleMissed() {
    // Non fallire se si manca un cerchio - genera semplicemente il prossimo
    // Il giocatore perde solo se non raggiunge 5 tocchi prima del timeout
    if (_gameActive) {
      Future.delayed(const Duration(milliseconds: 300), _spawnCircle);
    }
  }
}

class DisappearingCircle extends CircleComponent with TapCallbacks {
  final VoidCallback onTapped;
  final VoidCallback onMissed;
  late TimerComponent _disappearTimer;
  bool _tapped = false;

  DisappearingCircle({
    required Vector2 position,
    required this.onTapped,
    required this.onMissed,
  }) : super(
          radius: 40,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFF9800),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Disappear after 1 second
    _disappearTimer = TimerComponent(
      period: 1.0,
      repeat: false,
      onTick: () {
        if (!_tapped) {
          onMissed();
        }
        removeFromParent();
      },
    );
    add(_disappearTimer);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!_tapped) {
      _tapped = true;
      removeFromParent();
      onTapped();
    }
  }
}
