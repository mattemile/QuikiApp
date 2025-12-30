import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Tocca le talpe che appaiono casualmente
class WhackMoleGame extends QuikiBaseGame {
  final Random _random = Random();
  final List<MoleHole> _holes = [];
  int _molesWhacked = 0;
  final int _targetMoles = 10;
  bool _gameActive = true;
  // TODO: aggiungere suoni quando si colpisce una talpa

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Instructions
    final instructionText = TextComponent(
      text: 'Tocca le talpe!\n10 per vincere',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Score counter
    final scoreText = TextComponent(
      text: '0 / 10',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, 100),
      anchor: Anchor.center,
    );
    add(scoreText);

    // Create 9 holes in 3x3 grid
    final holeSize = (size.x - 40) / 3;

    for (int i = 0; i < 9; i++) {
      final row = i ~/ 3;
      final col = i % 3;

      final hole = MoleHole(
        position: Vector2(
          col * (holeSize + 5) + 10,
          size.y * 0.3 + row * (holeSize + 5),
        ),
        size: Vector2.all(holeSize),
        onMoleWhacked: () {
          _molesWhacked++;
          scoreText.text = '$_molesWhacked / 10';

          if (_molesWhacked >= _targetMoles) {
            _gameActive = false;
            completeGame(won: true, points: 100);
          }
        },
        onMoleMissed: () {
          // Non fallire per talpe mancate - il giocatore perde solo se non raggiunge 10 talpe prima del timeout
        },
      );
      _holes.add(hole);
      add(hole);
    }

    // Inizia a far apparire le talpe
    _spawnMole();
  }

  void _spawnMole() {
    if (!_gameActive) return;

    // Sceglie una buca casuale
    final hole = _holes[_random.nextInt(_holes.length)];

    if (!hole.hasMole) {
      hole.showMole();
    }

    // Pianifica la prossima talpa - spawn più veloce per migliore giocabilità
    final delay = 0.5 + _random.nextDouble() * 0.3; // 0.5-0.8 secondi
    Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), _spawnMole);
  }
}

class MoleHole extends PositionComponent with TapCallbacks {
  final VoidCallback onMoleWhacked;
  final VoidCallback onMoleMissed;
  bool hasMole = false;
  late Paint _holePaint;
  late Paint _molePaint;
  TimerComponent? _moleTimer;

  MoleHole({
    required Vector2 position,
    required Vector2 size,
    required this.onMoleWhacked,
    required this.onMoleMissed,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _holePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.fill;

    _molePaint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..style = PaintingStyle.fill;
  }

  void showMole() {
    if (hasMole) return;

    hasMole = true;

    // La talpa resta visibile 1.2 secondi - un po' più lungo per essere più giocabile
    _moleTimer = TimerComponent(
      period: 1.2,
      repeat: false,
      onTick: () {
        if (hasMole) {
          hasMole = false;
          onMoleMissed();
        }
      },
    );
    add(_moleTimer!);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw hole (circle)
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2 - 5,
      _holePaint,
    );

    // Draw mole if present
    if (hasMole) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 3,
        _molePaint,
      );

      // Draw eyes
      final eyePaint = Paint()..color = const Color(0xFF000000);
      canvas.drawCircle(
        Offset(size.x / 2 - 10, size.y / 2 - 5),
        3,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(size.x / 2 + 10, size.y / 2 - 5),
        3,
        eyePaint,
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (hasMole) {
      hasMole = false;
      _moleTimer?.timer.stop();
      onMoleWhacked();
    }
  }
}
