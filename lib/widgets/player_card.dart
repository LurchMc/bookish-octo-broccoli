import 'package:flutter/material.dart';
import '../models/player_data.dart';

class PlayerCard extends StatelessWidget {
  final PlayerData player;
  final int? forcedRotation;
  final VoidCallback onChanged;
  final Color accentColor;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onChanged,
    required this.accentColor,
    this.forcedRotation,
  });

  @override
  Widget build(BuildContext context) {
    final int currentRotation = forcedRotation ?? player.rotation;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: RotatedBox(
        quarterTurns: currentRotation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SPIELER ${player.id}', style: const TextStyle(fontSize: 12)),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '${player.life}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                  onPressed: () {
                    player.changeLife(-1);
                    onChanged();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 30),
                  onPressed: () {
                    player.changeLife(1);
                    onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}