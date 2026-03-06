import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';
import 'screens/lobby_screen.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set full screen for game feel
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const FreeFireCloneApp());
}

class FreeFireCloneApp extends StatelessWidget {
  const FreeFireCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FF Mini Battle Royale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFA500), // FF Orange
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/lobby': (context) => const LobbyScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
