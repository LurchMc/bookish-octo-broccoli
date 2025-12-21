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
  List<PlayerData> players = [];

  // --- 1. Logik-Methoden (initState, _setupPlayers etc.) ---
  @override
  void initState() {
    super.initState();
    _setupPlayers(3); // Beispielhaft mit 3 Spielern starten
  }

  void _setupPlayers(int count) {
    setState(() {
      players = List.generate(count, (index){
        return PlayerData(
          id: index +1,
          rotation: (index % 2 == 0) ? 1 : 3
        );
      });
    }
    );  
  }

  // 2. Die HAUPT-Build-Methode
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Hier rufen wir die Hilfsmethoden auf
          if (players.length == 2) return _buildDuelLayout();
          if (players.length == 3) return _buildBossLayout(3);
          if (players.length == 5) return _buildBossLayout(5);
          return _buildStandardGrid(constraints);
        },
      ),
    );
  }

  // --- 3. Die HILFS-Methoden (Implementierung) ---
  // Diese stehen UNTER der build-Methode, aber noch VOR der letzten Klammer der Klasse.

  Widget _buildDuelLayout() {
    return Row(
      children: [
        Expanded(child: PlayerCard(player: players[0])),
        Container(width: 2, color: Colors.grey[800]),
        Expanded(child: PlayerCard(player: players[1])),
      ],
    );
  }

  Widget _buildBossLayout(int totalPlayers) {
    return Row(
      children: [
        // kleine Kacheln
        Expanded(
          child: _buildStandardGrid(null, customCount: totalPlayers - 1),
        ),
        // Trennlinie
        Container(width: 2, color: Colors.amberAccent.withOpacity(0.3)),
        // Große Kachel
        Expanded(
          child: PlayerCard(player: players.last),
        ),
      ],
    );
  }

  Widget _buildStandardGrid(BoxConstraints? constraints, {int? customCount}) {
    int count = customCount ?? players.length;
    return GridView.builder(
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count <= 2 ? 1 : 2,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) => PlayerCard(player: players[index]),
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
