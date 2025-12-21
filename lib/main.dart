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

  // 1. Logik-Methoden (initState, _setupPlayers etc.)
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
      appBar: AppBar(
        title: const Text('MTG Life Counter'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (count) => _setupPlayers(count),
            itemBuilder: (context) => [2, 3, 4, 5, 6].map((n) => 
              PopupMenuItem(value: n, child: Text('$n Spieler'))).toList(),
          ),
        ],
      ),
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
      // Seite der Herausforderer (Spieler 1 und 2 bei insgesamt 3 Spielern)
      Expanded(
        flex: 1,
        child: Column(
          children: [
            for (int i = 0; i < totalPlayers - 1; i++)
              Expanded(
                child: PlayerCard(
                  player: players[i],
                  // Diese Spieler werden um 180 Grad gedreht (2 * 90°)
                  forcedRotation: 2, 
                ),
              ),
          ],
        ),
      ),
      
      Container(width: 2, color: Colors.amberAccent.withOpacity(0.4)),

      // Der BOSS (letzter Spieler in der Liste)
      Expanded(
        flex: 1,
        child: PlayerCard(
          player: players.last,
          // Der Boss schaut normal (0 Grad oder bleibt bei seiner Standard-Rotation)
          forcedRotation: 0, 
        ),
      ),
    ],
  );
}

 Widget _buildStandardGrid(BoxConstraints? constraints, {int? customCount}) {
  int count = customCount ?? players.length;
  int crossAxisCount = count <= 2 ? 1 : (count <= 4 ? 2 : 3);
  int rowCount = (count / crossAxisCount).ceil();

  // Falls wir in einem Boss-Layout sind, haben wir keine constraints, 
  // daher nutzen wir ein Standard-Verhältnis als Fallback.
  double aspectRatio = 1.0; 

  if (constraints != null) {
    // Hier berechnen wir, wie breit und hoch eine Kachel maximal sein darf
    final double availableWidth = constraints.maxWidth;
    final double availableHeight = constraints.maxHeight;
    
    final double itemWidth = availableWidth / crossAxisCount;
    final double itemHeight = availableHeight / rowCount;
    
    aspectRatio = itemWidth / itemHeight;
  }

  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(), // Wichtig: Deaktiviert Scrollen
    itemCount: count,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio, // Erzwingt, dass die Kacheln in den Screen passen
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
    ),
    itemBuilder: (context, index) => PlayerCard(player: players[index]),
  );
}

}

// --- Das Spieler-Kachel-Widget ---
class PlayerCard extends StatefulWidget {
  final PlayerData player;
  // 1. Die Variable hier definieren
  final int? forcedRotation; 

  const PlayerCard({
    super.key, 
    required this.player, 
    this.forcedRotation, // 2. Den Parameter hier im Konstruktor erlauben
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    // 3. Den Parameter hier verwenden (widget.forcedRotation)
    final int currentRotation = widget.forcedRotation ?? widget.player.rotation;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: widget.player.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: RotatedBox(
        quarterTurns: currentRotation, // <--- Wichtig: Hier wird die Drehung angewendet
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SPIELER ${widget.player.id}', style: const TextStyle(fontSize: 12)),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '${widget.player.life}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => setState(() => widget.player.life--),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
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

Widget _buildCompactButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Icon(icon, size: 30, color: Colors.white70),
  );
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
