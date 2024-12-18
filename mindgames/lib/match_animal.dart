import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MatchAnimalGame extends StatefulWidget {
  const MatchAnimalGame({super.key});
  @override
  State<MatchAnimalGame> createState() => _MatchAnimalGameState();
}

class _MatchAnimalGameState extends State<MatchAnimalGame> {
  @override
  void initState() {
    super.initState();
    // Force the screen to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Set the preferred orientations back to normal when disposing the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Animal Game'),
      ),
      body: const Center(
        child: Text('Match Animal Game in Landscape Mode'),
      ),
    );
  }
}
