import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../base_game.dart';

/// Rotate 4 pieces to align them correctly
class RotateFixGame extends QuikiBaseGame {
  final List<RotatablePiece> _pieces = [];
  final Random _random = Random();
  bool _gameActive = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create 4 pieces in a 2x2 grid
    final pieceSize = size.x / 2 - 20;

    for (int i = 0; i < 4; i++) {
      final row = i ~/ 2;
      final col = i % 2;

      // Random initial rotation (0, 90, 180, 270)
      final initialRotation = _random.nextInt(4) * (pi / 2);

      final piece = RotatablePiece(
        position: Vector2(
          col * (pieceSize + 20) + 10,
          row * (pieceSize + 20) + 10,
        ),
        size: Vector2.all(pieceSize),
        initialAngle: initialRotation,
        pieceIndex: i,
        onRotate: _checkWin,
      );

      _pieces.add(piece);
      add(piece);
    }
  }

  void _checkWin() {
    if (!_gameActive) return;

    // Check if all pieces are at 0 rotation (aligned)
    final allAligned = _pieces.every((p) => p.isAligned);
    if (allAligned) {
      _gameActive = false;
      completeGame(won: true, points: 100);
    }
  }
}

class RotatablePiece extends PositionComponent with TapCallbacks {
  final int pieceIndex;
  final VoidCallback onRotate;
  double currentAngle;
  late Paint _paint;
  late Paint _linePaint;

  RotatablePiece({
    required Vector2 position,
    required Vector2 size,
    required double initialAngle,
    required this.pieceIndex,
    required this.onRotate,
  })  : currentAngle = initialAngle,
        super(position: position, size: size);

  bool get isAligned => currentAngle % (2 * pi) < 0.1;

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = const Color(0xFF7E57C2)
      ..style = PaintingStyle.fill;

    _linePaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(currentAngle);
    canvas.translate(-size.x / 2, -size.y / 2);

    // Draw piece background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      _paint,
    );

    // Draw arrow pointing up to show orientation
    final arrowPath = Path()
      ..moveTo(size.x / 2, size.y * 0.2)
      ..lineTo(size.x * 0.3, size.y * 0.5)
      ..lineTo(size.x * 0.7, size.y * 0.5)
      ..close();
    canvas.drawPath(arrowPath, _linePaint);

    canvas.restore();
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Rotate 90 degrees clockwise
    currentAngle += pi / 2;
    if (currentAngle >= 2 * pi) {
      currentAngle = 0;
    }
    onRotate();
  }
}
