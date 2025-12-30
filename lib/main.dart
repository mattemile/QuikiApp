import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/game_manager.dart';
import 'core/storage.dart';
import 'core/game_registry.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize storage
  final storage = await GameStorage.create();

  // Create game manager
  final gameManager = GameManager(storage: storage);

  // Register all games
  gameManager.registerGames(GameRegistry.getAllGames());

  runApp(QuikiApp(gameManager: gameManager));
}

class QuikiApp extends StatelessWidget {
  final GameManager gameManager;

  const QuikiApp({super.key, required this.gameManager});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameManager,
      child: MaterialApp(
        title: 'QuikiApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
