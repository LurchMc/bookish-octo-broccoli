import 'package:flutter/material.dart';
import '../models/player_data.dart';
import 'player_card.dart';

class LayoutTemplates {
  static Widget buildLayout({
    required List<PlayerData> players,
    required BoxConstraints constraints,
    required VoidCallback onUpdate,
  }) {
    final int count = players.length;
    if (count == 2) return _buildDuelLayout(players, onUpdate);
    if (count == 3 || count == 5) return _buildBossLayout(players, onUpdate);
    if (count == 6) return _buildSixPlayerLayout(players, constraints, onUpdate);
    return _buildStandardGrid(players, constraints, onUpdate);
  }

  static Widget _buildDuelLayout(List<PlayerData> players, VoidCallback onUpdate) {
    return Row(
      children: [
        Expanded(child: PlayerCard(player: players[0], onChanged: onUpdate, accentColor: Colors.grey,)),
        Container(width: 1, color: Colors.white24),
        Expanded(child: PlayerCard(player: players[1], onChanged: onUpdate, accentColor: Colors.grey,)),
      ],
    );
  }

static Widget _buildBossLayout(List<PlayerData> players, VoidCallback onUpdate) {
  return Row(
    children: [
      // LINKE SEITE: Die Herausforderer
      Expanded(
        flex: 1,
        child: players.length <= 3 
          ? _buildChallengers3(players, onUpdate) // Layout für 3 Spieler
          : _buildChallengers5(players, onUpdate), // Layout für 5 Spieler
      ),

      // Trennlinie
      Container(width: 2, color: Colors.amberAccent.withOpacity(0.4)),

      // RECHTE SEITE: Der Boss
      Expanded(
        flex: 1,
        child: PlayerCard(
          player: players.last,
          forcedRotation: 3,
          onChanged: onUpdate, accentColor: Colors.grey,
        ),
      ),
    ],
  );
}

// Hilfslayout für 3 Spieler (Herausforderer untereinander, entgegengesetzt)
static Widget _buildChallengers3(List<PlayerData> players, VoidCallback onUpdate) {
  return Column(
    children: [
      Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
      Expanded(child: PlayerCard(player: players[1], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
    ],
  );
}

// Hilfslayout für 5 Spieler (2x2 Gitter, gegenüberliegend)
static Widget _buildChallengers5(List<PlayerData> players, VoidCallback onUpdate) {
  return Column(
    children: [
      // Obere Reihe (Spieler 1 & 2 schauen nach "oben" / Weg vom Boss)
      Expanded(
        child: Row(
          children: [
            Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
            Expanded(child: PlayerCard(player: players[1], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
          ],
        ),
      ),
      // Untere Reihe (Spieler 3 & 4 schauen nach "unten" / Weg vom Boss)
      Expanded(
        child: Row(
          children: [
            Expanded(child: PlayerCard(player: players[2], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
            Expanded(child: PlayerCard(player: players[3], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
          ],
        ),
      ),
    ],
  );
}

  static Widget _buildStandardGrid(List<PlayerData> players, BoxConstraints constraints, VoidCallback onUpdate) {
    int crossAxisCount = players.length <= 4 ? 2 : 3;
    int rowCount = (players.length / crossAxisCount).ceil();
    
    double availableWidth = constraints.maxWidth;
    double availableHeight = constraints.maxHeight;
    double aspectRatio = 1.0;

    if (availableHeight > 0 && availableHeight.isFinite && availableWidth > 0) {
      double itemHeight = availableHeight / rowCount;
      if (itemHeight > 0) {
        aspectRatio = (availableWidth / crossAxisCount) / itemHeight;
      }
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: players.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio > 0 ? aspectRatio : 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) => PlayerCard(player: players[index], onChanged: onUpdate, accentColor: Colors.grey,),
    );
  }
}

Widget _buildSixPlayerLayout(List<PlayerData> players, BoxConstraints constraints, VoidCallback onUpdate) {
  return Column(
    children: [
      // OBERE REIHE (3 Spieler)
      Expanded(
        child: Row(
          children: [
            // Spieler 1: Schaut nach links
            Expanded(child: PlayerCard(player: players[0], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
            // Spieler 2: Schaut "nach oben" (180 Grad gedreht zum User)
            Expanded(child: PlayerCard(player: players[1], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
            // Spieler 3: Schaut nach rechts
            Expanded(child: PlayerCard(player: players[2], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
          ],
        ),
      ),
      
      // Mittlere Trennlinie (optional)
      Container(height: 1, color: Colors.white10),

      // UNTERE REIHE (3 Spieler)
      Expanded(
        child: Row(
          children: [
            // Spieler 4: Schaut nach links
            Expanded(child: PlayerCard(player: players[3], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
            // Spieler 5: Schaut normal (0 Grad)
            Expanded(child: PlayerCard(player: players[4], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
            // Spieler 6: Schaut nach rechts
            Expanded(child: PlayerCard(player: players[5], forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
          ],
        ),
      ),
    ],
  );
}