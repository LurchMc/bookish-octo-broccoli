class PlayerData {
  int id;
  int life;
  int rotation;

  PlayerData({
    required this.id,
    this.life = 40,
    required this.rotation,
  });

  void changeLife(int amount) {
    life += amount;
  }
}