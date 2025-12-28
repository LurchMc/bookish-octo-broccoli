import 'package:flutter/material.dart';

class PlayerData {
  final int id;
  int life;
  Color color;
  // Speichert: Angreifer-ID -> Schadenspunkte
  Map<int, int> commanderDamage = {};

  PlayerData({
    required this.id,
    this.life = 40,
    this.color = const Color(0xFF263238),
  });

  void changeLife(int amount) {
    life += amount;
  }
}