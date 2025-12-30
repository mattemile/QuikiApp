import '../models/game_config.dart';
import '../games/logic/find_intruder_game.dart';
import '../games/logic/memory_flash_game.dart';
import '../games/logic/sequence_game.dart';
import '../games/visual/color_diff_game.dart';
import '../games/visual/rotate_fix_game.dart';
import '../games/visual/find_pair_game.dart';
import '../games/reflex/tap_green_game.dart';
import '../games/reflex/tap_escape_game.dart';
import '../games/reflex/whack_mole_game.dart';
import '../games/math/fast_sum_game.dart';
import '../games/math/multiples_game.dart';
import '../games/math/higher_lower_game.dart';
import '../games/creativity/one_line_game.dart';
import '../games/precision/stop_timer_game.dart';
import '../games/precision/precise_stop_game.dart';

/// Registro di tutti i giochi disponibili
class GameRegistry {
  static List<GameConfig> getAllGames() {
    return [
      // Giochi di logica
      GameConfig(
        id: 'find_intruder',
        name: 'Trova l\'intruso',
        description: '4 simboli → uno diverso → tocca',
        category: GameCategory.logic,
        gameBuilder: () => FindIntruderGame(),
        maxDuration: 30,
      ),
      GameConfig(
        id: 'memory_flash',
        name: 'Memory Flash',
        description: 'Ricorda e trova la coppia',
        category: GameCategory.logic,
        gameBuilder: () => MemoryFlashGame(),
        maxDuration: 45,
      ),
      GameConfig(
        id: 'sequence',
        name: 'Sequenza Crescente',
        description: 'Tocca i numeri in ordine crescente',
        category: GameCategory.logic,
        gameBuilder: () => SequenceGame(),
        maxDuration: 40,
      ),

      // Giochi visivi
      GameConfig(
        id: 'color_diff',
        name: 'Colore diverso',
        description: 'Trova la sfumatura differente',
        category: GameCategory.visual,
        gameBuilder: () => ColorDiffGame(),
        maxDuration: 30,
      ),
      GameConfig(
        id: 'rotate_fix',
        name: 'Ruota & completa',
        description: 'Rimetti dritti i pezzi ruotati',
        category: GameCategory.visual,
        gameBuilder: () => RotateFixGame(),
        maxDuration: 45,
      ),
      GameConfig(
        id: 'find_pair',
        name: 'Trova la Coppia',
        description: 'Trova i 2 simboli identici',
        category: GameCategory.visual,
        gameBuilder: () => FindPairGame(),
        maxDuration: 30,
      ),

      // Giochi di riflessi
      GameConfig(
        id: 'tap_green',
        name: 'Tap Verde',
        description: 'Premi quando diventa verde',
        category: GameCategory.reflex,
        gameBuilder: () => TapGreenGame(),
        maxDuration: 20,
      ),
      GameConfig(
        id: 'tap_escape',
        name: 'Tocca & scappa',
        description: 'Tocca i cerchi prima che spariscano',
        category: GameCategory.reflex,
        gameBuilder: () => TapEscapeGame(),
        maxDuration: 30,
      ),
      GameConfig(
        id: 'whack_mole',
        name: 'Whack-a-Mole',
        description: 'Tocca le talpe che appaiono',
        category: GameCategory.reflex,
        gameBuilder: () => WhackMoleGame(),
        maxDuration: 40,
      ),

      // Giochi di matematica
      GameConfig(
        id: 'fast_sum',
        name: 'Somma Sprint',
        description: 'Calcoli veloci con tempo breve',
        category: GameCategory.math,
        gameBuilder: () => FastSumGame(),
        maxDuration: 30,
      ),
      GameConfig(
        id: 'multiples',
        name: 'Multipli',
        description: 'Tocca solo i multipli di 3',
        category: GameCategory.math,
        gameBuilder: () => MultiplesGame(),
        maxDuration: 40,
      ),
      GameConfig(
        id: 'higher_lower',
        name: 'Maggiore o Minore',
        description: 'Tocca il numero maggiore',
        category: GameCategory.math,
        gameBuilder: () => HigherLowerGame(),
        maxDuration: 35,
      ),

      // Giochi di creatività
      GameConfig(
        id: 'one_line',
        name: 'Linea unica',
        description: 'Collega tutti i punti senza ripassare',
        category: GameCategory.creativity,
        gameBuilder: () => OneLineGame(),
        maxDuration: 60,
      ),

      // Giochi di precisione
      GameConfig(
        id: 'stop_timer',
        name: 'Stop a 10.00',
        description: 'Ferma il cronometro al decimo preciso',
        category: GameCategory.precision,
        gameBuilder: () => StopTimerGame(),
        maxDuration: 20,
      ),
      GameConfig(
        id: 'precise_stop',
        name: 'Fermata Precisa',
        description: 'Ferma la barra sulla zona verde',
        category: GameCategory.precision,
        gameBuilder: () => PreciseStopGame(),
        maxDuration: 30,
      ),
    ];
  }
}
