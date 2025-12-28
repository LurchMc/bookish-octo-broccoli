import 'package:flutter/material.dart';
import '../models/player_data.dart';
import 'player_card.dart';

class LayoutTemplates {
  static Widget buildLayout({
    required List<PlayerData> players,
    required BoxConstraints constraints,
    required VoidCallback onUpdate,
    required Function(PlayerData) onLongPressPlayer,
  }) {
    final int count = players.length;
    if (count == 2) return _buildDuelLayout(players, onUpdate, onLongPressPlayer);
    if (count == 3 || count == 5) return _buildBossLayout(players, onUpdate, onLongPressPlayer);
    if (count == 6) return _buildSixPlayerLayout(players, onUpdate, onLongPressPlayer);
    return _buildStandardGrid(players, constraints, onUpdate, onLongPressPlayer);
  }

  static Widget _buildBossLayout(List<PlayerData> players, VoidCallback onUpdate, Function(PlayerData) onLongPress) {
    return Row(
      children: [
        Expanded(
          child: players.length <= 3 
            ? _buildChallengers3(players, onUpdate, onLongPress)
            : _buildChallengers5(players, onUpdate, onLongPress),
        ),
        Container(width: 2, color: Colors.amberAccent.withOpacity(0.4)),
        Expanded(
          child: PlayerCard(
            player: players.last,
            forcedRotation: 3,
            onChanged: onUpdate,
            onLongPress: () => onLongPress(players.last),
          ),
        ),
      ],
    );
  }

  static Widget _buildChallengers3(List<PlayerData> players, VoidCallback onUpdate, Function(PlayerData) lp) {
    return Column(
      children: [
        Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[0]))),
        Expanded(child: PlayerCard(player: players[1], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[1]))),
      ],
    );
  }

  static Widget _buildChallengers5(List<PlayerData> players, VoidCallback onUpdate, Function(PlayerData) lp) {
    return Column(
      children: [
        Expanded(child: Row(children: [
          Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[0]))),
          Expanded(child: PlayerCard(player: players[1], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[1]))),
        ])),
        Expanded(child: Row(children: [
          Expanded(child: PlayerCard(player: players[2], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[2]))),
          Expanded(child: PlayerCard(player: players[3], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[3]))),
        ])),
      ],
    );
  }

  static Widget _buildSixPlayerLayout(List<PlayerData> players, VoidCallback onUpdate, Function(PlayerData) lp) {
    return Column(
      children: [
        Expanded(child: Row(children: [
          Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[0]))),
          Expanded(child: PlayerCard(player: players[1], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[1]))),
          Expanded(child: PlayerCard(player: players[2], forcedRotation: 2, onChanged: onUpdate, onLongPress: () => lp(players[2]))),
        ])),
        Expanded(child: Row(children: [
          Expanded(child: PlayerCard(player: players[3], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[3]))),
          Expanded(child: PlayerCard(player: players[4], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[4]))),
          Expanded(child: PlayerCard(player: players[5], forcedRotation: 0, onChanged: onUpdate, onLongPress: () => lp(players[5]))),
        ])),
      ],
    );
  }

  // Hilfsmethoden für Duel und Grid (vereinfacht)
 static Widget _buildDuelLayout(List<PlayerData> p, VoidCallback u, Function(PlayerData) lp) {
    return Row( // Row sorgt dafür, dass die Kacheln als vertikale Spalten nebeneinander stehen
      children: [
        // Linke Kachel (Spieler 1)
        Expanded(
          child: PlayerCard(
            player: p[0], 
            forcedRotation: 1, // Dreht den Inhalt um 90° nach links
            onChanged: u, 
            onLongPress: () => lp(p[0])
          ),
        ),
        
        // Eine dünne Linie als Trenner zwischen den Spielern
        Container(width: 1, color: Colors.white10),

        // Rechte Kachel (Spieler 2)
        Expanded(
          child: PlayerCard(
            player: p[1], 
            forcedRotation: 3, // Dreht den Inhalt um 90° nach rechts (270°)
            onChanged: u, 
            onLongPress: () => lp(p[1])
          ),
        ),
      ],
    );
  }

  static Widget _buildStandardGrid(List<PlayerData> p, BoxConstraints c, VoidCallback u, Function(PlayerData) lp) {
    // Wir teilen die Liste in zwei Reihen auf (für ein 2x2 Gitter bei 4 Spielern)
    return Column(
      children: [
        // Obere Reihe (Spieler 1 und 2)
        Expanded(
          child: Row(
            children: [
              Expanded(child: PlayerCard(player: p[0], forcedRotation: 2, onChanged: u, onLongPress: () => lp(p[0]))),
              Expanded(child: PlayerCard(player: p[1], forcedRotation: 2, onChanged: u, onLongPress: () => lp(p[1]))),
            ],
          ),
        ),
        // Untere Reihe (Spieler 3 und 4)
        Expanded(
          child: Row(
            children: [
              Expanded(child: PlayerCard(player: p[2], forcedRotation: 0, onChanged: u, onLongPress: () => lp(p[2]))),
              Expanded(child: PlayerCard(player: p[3], forcedRotation: 0, onChanged: u, onLongPress: () => lp(p[3]))),
            ],
          ),
        ),
      ],
    );
  }
}