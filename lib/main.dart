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
    appBar: AppBar(
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
    body: LayoutBuilder(
      builder: (context, constraints) {
        // Wir holen uns die Gesamtmaße des verfügbaren Bildschirms
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;

        // Bestimme Spalten (Columns) und Zeilen (Rows) basierend auf Spielerzahl
        int crossAxisCount = players.length <= 2 ? 1 : (players.length <= 4 ? 2 : 3);
        int rowCount = (players.length / crossAxisCount).ceil();

        // Berechne die perfekte Breite und Höhe für jede Kachel
        final double itemWidth = screenWidth / crossAxisCount;
        final double itemHeight = screenHeight / rowCount;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Verhindert Scrollen
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: itemWidth / itemHeight, // Das Geheimnis für die Passform!
          ),
          itemCount: players.length,
          itemBuilder: (context, index) {
            return PlayerCard(
              player: players[index],
            );
          },
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
  // Innerhalb der build-Methode von _PlayerCardState
@override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(2), // Kleinerer Rand spart Platz
    decoration: BoxDecoration(
      color: widget.player.color,
      border: Border.all(color: Colors.white12),
      borderRadius: BorderRadius.circular(8),
    ),
    child: RotatedBox(
      quarterTurns: widget.player.rotation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('P${widget.player.id}', style: const TextStyle(fontSize: 12)),
            
            // FittedBox sorgt dafür, dass die Zahl immer reinpasst!
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '${widget.player.life}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            // Buttons kleiner machen für 6 Spieler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactButton(Icons.remove, () => setState(() => widget.player.life--)),
                _buildCompactButton(Icons.add, () => setState(() => widget.player.life++)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCompactButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Icon(icon, size: 30, color: Colors.white70),
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
