import 'package:flutter/material.dart';

class PlayerData {
  int id;
  int life;
  Color color;
  int rotation;

  PlayerData({
    required this.id,
    this.life = 40,
    this.color = const Color(0xFF263238),
    required this.rotation,
  });

  void changeLife(int amount) {
    life += amount;
  }
}