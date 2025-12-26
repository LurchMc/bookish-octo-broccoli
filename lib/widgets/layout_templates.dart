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
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < players.length - 1; i++)
                Expanded(child: PlayerCard(player: players[i], forcedRotation: 2, onChanged: onUpdate, accentColor: Colors.grey,)),
            ],
          ),
        ),
        Container(width: 2, color: Colors.amberAccent.withOpacity(0.5)),
        Expanded(child: PlayerCard(player: players.last, forcedRotation: 0, onChanged: onUpdate, accentColor: Colors.grey,)),
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