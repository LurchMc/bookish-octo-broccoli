import 'package:flutter/material.dart';
import '../models/player_data.dart';
import '../widgets/layout_templates.dart';

class LifeCounterScreen extends StatefulWidget {
  const LifeCounterScreen({super.key});

  @override
  State<LifeCounterScreen> createState() => _LifeCounterScreenState();
}

class _LifeCounterScreenState extends State<LifeCounterScreen> {
  List<PlayerData> players = [];

  @override
  void initState() {
    super.initState();
    _setupPlayers(4);
  }

  void _setupPlayers(int count) {
    setState(() {
      players = List.generate(count, (index) {
        return PlayerData(
          id: index + 1,
          rotation: (index % 2 == 0) ? 1 : 3,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('MTG Life Counter'),
        actions: [
          PopupMenuButton<int>(
            onSelected: _setupPlayers,
            itemBuilder: (context) => [2, 3, 4, 5, 6]
                .map((n) => PopupMenuItem(value: n, child: Text('$n Spieler')))
                .toList(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return LayoutTemplates.buildLayout(
            players: players,
            constraints: constraints,
            onUpdate: () => setState(() {}),
          );
        },
      ),
    );
  }
}