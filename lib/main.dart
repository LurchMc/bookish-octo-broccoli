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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Linke Hälfte: Spieler 1
          Expanded(
            child: PlayerCard(
              playerNumber: 1,
              rotation: 1, // 90 Grad Drehung
              cardColor: Colors.blueGrey[900]!,
            ),
          ),
          
          // Trennlinie in der Mitte
          Container(width: 2, color: Colors.grey[800]),
          
          // Rechte Hälfte: Spieler 2
          Expanded(
            child: PlayerCard(
              playerNumber: 2,
              rotation: 3, // 270 Grad Drehung (gegenüberliegend)
              cardColor: Colors.redAccent.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Das Spieler-Kachel-Widget ---
class PlayerCard extends StatefulWidget {
  final int playerNumber;
  final int rotation;
  final Color cardColor;

  const PlayerCard({
    super.key,
    required this.playerNumber,
    required this.rotation,
    required this.cardColor,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  int life = 40;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.cardColor,
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Stack( // Stack erlaubt es, Elemente übereinander zu legen
          children: [
            // Spieler-Nummer im Hintergrund oder oben
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'SPIELER ${widget.playerNumber}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            
            // Haupt-Inhalt: Lebenspunkte und Buttons
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$life',
                    style: const TextStyle(
                      fontSize: 100, // Schön groß für die kurze Seite
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(Icons.remove, () => setState(() => life--)),
                      const SizedBox(width: 40),
                      _buildActionButton(Icons.add, () => setState(() => life++)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}