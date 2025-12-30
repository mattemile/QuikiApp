import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../core/game_manager.dart';
import '../games/base_game.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  QuikiBaseGame? _currentGame;

  @override
  void initState() {
    super.initState();
    _startNextGame();
  }

  void _startNextGame() {
    final gameManager = context.read<GameManager>();

    if (gameManager.isGameOver) {
      // Navigate to results
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
      });
      return;
    }

    final gameConfig = gameManager.pickRandomGame();
    if (gameConfig == null) return;

    setState(() {
      _currentGame = gameConfig.gameBuilder() as QuikiBaseGame;
      _currentGame!.onGameComplete = (won, points) async {
        if (won) {
          await gameManager.onGameWon(points);
        } else {
          await gameManager.onGameLost();
        }

        // Wait a bit then load next game
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _startNextGame();
        }
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = context.watch<GameManager>();

    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
        child: Column(
          children: [
            // Header with stats
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A237E),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _HeaderStat(
                    label: 'Vite',
                    value: '❤️' * gameManager.lives,
                    color: Colors.red,
                  ),
                  _HeaderStat(
                    label: 'Punteggio',
                    value: gameManager.currentScore.toString(),
                    color: Colors.amber,
                  ),
                  _HeaderStat(
                    label: 'Serie',
                    value: gameManager.streak.toString(),
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            // Game title
            if (gameManager.currentGame != null)
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF37474F),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      gameManager.currentGame!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gameManager.currentGame!.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

            // Game area
            Expanded(
              child: _currentGame != null
                  ? GameWidget(game: _currentGame!)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _HeaderStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
