import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiki_app/main.dart';
import 'package:quiki_app/core/storage.dart';
import 'package:quiki_app/core/game_manager.dart';
import 'package:quiki_app/core/game_registry.dart';

void main() {
  testWidgets('QuikiApp smoke test', (WidgetTester tester) async {
    // Initialize storage for test
    final storage = await GameStorage.create();
    final gameManager = GameManager(storage: storage);
    gameManager.registerGames(GameRegistry.getAllGames());

    // Build our app and trigger a frame.
    await tester.pumpWidget(QuikiApp(gameManager: gameManager));

    // Verify that the home screen shows the QuikiApp title
    expect(find.text('QuikiApp'), findsOneWidget);
    expect(find.text('GIOCA'), findsOneWidget);
  });
}
