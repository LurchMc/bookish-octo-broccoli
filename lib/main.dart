import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Diese Zeile stellt sicher, dass die App im Querformat startet
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(const MagicLifeCounterApp());
}

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
}

class MagicLifeCounterApp extends StatelessWidget {
  const MagicLifeCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MTG Life Counter',
      theme: ThemeData.dark(), // Dunkles Design für MTG
      home: const LifeCounterScreen(),
    );
  }
}

// --- Der Hauptbildschirm ---
class LifeCounterScreen extends StatefulWidget {
  const LifeCounterScreen({super.key});

  @override
  State<LifeCounterScreen> createState() => _LifeCounterScreenState();
}

class _LifeCounterScreenState extends State<LifeCounterScreen> {
  // Unsere Liste der aktuell aktiven Spieler
  List<PlayerData> players = [];

  @override
  void initState() {
    super.initState();
    _setupPlayers(4); // Wir starten standardmäßig mal mit 4 Spielern
  }

  void _setupPlayers(int count) {
    setState(() {
      players = List.generate(count, (index) {
        // Logik für die Rotation: 
        // In einem 4er Grid schauen die oberen nach "oben", die unteren nach "unten"
        // Für den Anfang lassen wir sie alle mal bei 1 oder 3 (seitlich), wie gehabt.
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
      // Ein kleiner Button oben, um die Spieleranzahl zu wählen
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('MTG Life Counter'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.group_add),
            onSelected: (count) => _setupPlayers(count),
            itemBuilder: (context) => [2, 3, 4, 5, 6].map((int n) {
              return PopupMenuItem<int>(value: n, child: Text('$n Spieler'));
            }).toList(),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: players.length <= 2 ? 1 : 2, // 1 Spalte bei 2 Spielern, sonst 2
          childAspectRatio: players.length <= 2 ? 1.5 : 0.8,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) {
          return PlayerCard(
            key: ValueKey(players[index].id), // Wichtig für Flutter beim Neuzeichnen
            player: players[index],
          );
        },
      ),
    );
  }
}

// --- Das Spieler-Kachel-Widget ---
class PlayerCard extends StatefulWidget {
  final PlayerData player;
  const PlayerCard({super.key, required this.player});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.player.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RotatedBox(
        quarterTurns: widget.player.rotation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SPIELER ${widget.player.id}'),
            Text(
              '${widget.player.life}',
              style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 40),
                  onPressed: () => setState(() => widget.player.life--),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 40),
                  onPressed: () => setState(() => widget.player.life++),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  // Hilfs-Funktion für die Buttons, um Code-Wiederholung zu vermeiden
  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Icon(icon, size: 40, color: Colors.white),
      ),
    );
  }
