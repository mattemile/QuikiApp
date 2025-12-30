import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../base_game.dart';

/// Collega tutti i punti senza ripassare
class OneLineGame extends QuikiBaseGame with DragCallbacks {
  final List<DotComponent> _dots = [];
  final List<LineSegment> _lines = [];
  DotComponent? _currentDot;
  late int _totalDots;
  bool _gameActive = true;
  // forse 8 punti invece di 6? renderebbe il gioco più difficile

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create 6 dots in random pattern
    _totalDots = 6;
    final positions = _generateRandomPattern();

    for (int i = 0; i < _totalDots; i++) {
      final dot = DotComponent(
        position: positions[i],
        index: i,
      );
      _dots.add(dot);
      add(dot);
    }

    // Instructions
    final instructionText = TextComponent(
      text: 'Collega tutti i punti\nsenza ripassare!',
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
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!_gameActive) return;
    // Controlla se ha iniziato su un punto
    for (final dot in _dots) {
      if (_isPointInDot(event.localPosition, dot)) {
        _currentDot = dot;
        dot.markVisited();
        break;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_gameActive || _currentDot == null) return;

    // Controlla se è sopra un nuovo punto
    for (final dot in _dots) {
      if (dot == _currentDot || dot.isVisited) continue;

      if (_isPointInDot(event.localEndPosition, dot)) {
        // Controlla se la linea esiste già
        if (!_hasLine(_currentDot!, dot)) {
          _addLine(_currentDot!, dot);
          dot.markVisited();
          _currentDot = dot;

          // Controlla condizione vittoria
          if (_allDotsVisited()) {
            _gameActive = false;
            completeGame(won: true, points: 100);
          }
        } else {
          // Ripassato su una linea - fail
          _gameActive = false;
          failGame();
          return;
        }
        break;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _currentDot = null;
  }

  bool _isPointInDot(Vector2 point, DotComponent dot) {
    final distance = (point - dot.position).length;
    return distance < 30;
  }

  bool _hasLine(DotComponent a, DotComponent b) {
    return _lines.any((line) =>
        (line.start == a && line.end == b) || (line.start == b && line.end == a));
  }

  void _addLine(DotComponent start, DotComponent end) {
    final line = LineSegment(start: start, end: end);
    _lines.add(line);
    add(line);
  }

  bool _allDotsVisited() {
    return _dots.every((dot) => dot.isVisited);
  }

  /// Genera pattern casuali di punti
  List<Vector2> _generateRandomPattern() {
    final random = Random();
    final patterns = [
      // Pattern 1: Due righe
      [
        Vector2(size.x * 0.25, size.y * 0.35),
        Vector2(size.x * 0.5, size.y * 0.35),
        Vector2(size.x * 0.75, size.y * 0.35),
        Vector2(size.x * 0.25, size.y * 0.65),
        Vector2(size.x * 0.5, size.y * 0.65),
        Vector2(size.x * 0.75, size.y * 0.65),
      ],
      // Pattern 2: Cerchio
      [
        Vector2(size.x * 0.5, size.y * 0.25),
        Vector2(size.x * 0.75, size.y * 0.4),
        Vector2(size.x * 0.75, size.y * 0.6),
        Vector2(size.x * 0.5, size.y * 0.75),
        Vector2(size.x * 0.25, size.y * 0.6),
        Vector2(size.x * 0.25, size.y * 0.4),
      ],
      // Pattern 3: Diamante
      [
        Vector2(size.x * 0.5, size.y * 0.25),
        Vector2(size.x * 0.7, size.y * 0.4),
        Vector2(size.x * 0.7, size.y * 0.6),
        Vector2(size.x * 0.5, size.y * 0.75),
        Vector2(size.x * 0.3, size.y * 0.6),
        Vector2(size.x * 0.3, size.y * 0.4),
      ],
      // Pattern 4: Triangolo con centro
      [
        Vector2(size.x * 0.5, size.y * 0.3),
        Vector2(size.x * 0.75, size.y * 0.7),
        Vector2(size.x * 0.25, size.y * 0.7),
        Vector2(size.x * 0.5, size.y * 0.5),
        Vector2(size.x * 0.625, size.y * 0.6),
        Vector2(size.x * 0.375, size.y * 0.6),
      ],
      // Pattern 5: Zigzag verticale
      [
        Vector2(size.x * 0.3, size.y * 0.3),
        Vector2(size.x * 0.7, size.y * 0.4),
        Vector2(size.x * 0.3, size.y * 0.5),
        Vector2(size.x * 0.7, size.y * 0.6),
        Vector2(size.x * 0.3, size.y * 0.7),
        Vector2(size.x * 0.5, size.y * 0.8),
      ],
    ];

    // Scegli pattern casuale
    return patterns[random.nextInt(patterns.length)];
  }
}

class DotComponent extends CircleComponent {
  final int index;
  bool isVisited = false;

  DotComponent({
    required Vector2 position,
    required this.index,
  }) : super(
          radius: 20,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFBDBDBD),
        );

  void markVisited() {
    isVisited = true;
    paint.color = const Color(0xFF4CAF50);
  }
}

class LineSegment extends Component {
  final DotComponent start;
  final DotComponent end;
  late Paint _linePaint;

  LineSegment({required this.start, required this.end});

  @override
  Future<void> onLoad() async {
    _linePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(
      start.position.toOffset(),
      end.position.toOffset(),
      _linePaint,
    );
  }
}
