import 'package:flutter/material.dart';
import '../models/player_data.dart';

class PlayerCard extends StatelessWidget {
  final PlayerData player;
  final VoidCallback onChanged;
  final VoidCallback? onLongPress;
  final int forcedRotation;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onChanged,
    this.onLongPress,
    this.forcedRotation = 0,
  });

  @override
Widget build(BuildContext context) {
  // Prüfen, ob dieser Spieler bereits 21+ Schaden erhalten hat
  bool hasLostByCommander = player.commanderDamage.values.any((v) => v >= 21);

  return RotatedBox(
    quarterTurns: forcedRotation,
    child: GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hasLostByCommander ? Colors.red[900] : player.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasLostByCommander ? Colors.redAccent : Colors.white10,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // SPIELERNAME (Oben links in der Kachel)
            Positioned(
              top: 12,
              child: Text(
                "Spieler ${player.id}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Anzeige bei Commander-Niederlage
            if (hasLostByCommander)
              const Positioned(
                top: 35,
                child: Text(
                  "DEAD BY COMMANDER",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),

            // Lebenspunkte Anzeige
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${player.life}',
                  style: const TextStyle(
                    fontSize: 72, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Icon(Icons.remove, color: Colors.white.withOpacity(0.2), size: 40),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.add, color: Colors.white.withOpacity(0.2), size: 40),
        ),
      ],
    ),
            // Plus/Minus Zonen (Transparent über der ganzen Kachel)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () { player.changeLife(-1); onChanged(); },
                    child: const SizedBox.expand(), // Unsichtbare Klickzone links
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () { player.changeLife(1); onChanged(); },
                    child: const SizedBox.expand(), // Unsichtbare Klickzone rechts
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}