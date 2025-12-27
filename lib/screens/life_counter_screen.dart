import 'package:flutter/material.dart';
import '../models/player_data.dart';
import '../widgets/layout_templates.dart';

class LifeCounterScreen extends StatefulWidget {
  const LifeCounterScreen({super.key});

  @override
  State<LifeCounterScreen> createState() => _LifeCounterScreenState();
}

class _LifeCounterScreenState extends State<LifeCounterScreen> {
  List<PlayerData> players = [];
  int currentStartingLife = 40; // Merken für Reset
  // Dieser Controller steuert und liest den Text im Dialog
  final TextEditingController _lifeController = TextEditingController(text: '40');

  @override
  void initState() {
    super.initState();
    _setupPlayers(3, 40);
  }

  @override
  void dispose() {
    _lifeController.dispose(); // Wichtig: Speicher freigeben
    super.dispose();
  }

  void _setupPlayers(int count, int startingLife) {
    setState(() {
      currentStartingLife = startingLife;
      players = List.generate(count, (index) {
        return PlayerData(
          id: index + 1,
          life: startingLife,
          rotation: (index % 2 == 0) ? 1 : 3,
        );
      });
    });
  }

  // Diese Funktion öffnet den Dialog im Design deines Screenshots
  void _showSettingsDialog() {
  int tempPlayerCount = players.length;
  // Wir setzen den aktuellen Wert in den Controller, bevor der Dialog öffnet
  _lifeController.text = currentStartingLife.toString();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900], // Dunkles Design passend zum Screenshot
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Game Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Configure the number of players and starting life", 
                  style: TextStyle(fontSize: 14, color: Colors.grey[400])),
              ],
            ),
           content: SingleChildScrollView( // Fügt Scrollbarkeit hinzu
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Number of Players", style: TextStyle(color: Colors.white70, fontSize: 12)),
      DropdownButton<int>(
        value: tempPlayerCount,
        isExpanded: true,
        dropdownColor: Colors.grey[850],
        style: const TextStyle(color: Colors.white, fontSize: 18),
        items: [2, 3, 4, 5, 6].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text("$value Players"),
          );
        }).toList(),
        onChanged: (val) => setDialogState(() => tempPlayerCount = val!),
      ),
      const SizedBox(height: 20),
      const Text("Starting Health Points", style: TextStyle(color: Colors.white70, fontSize: 12)),
      TextField(
        controller: _lifeController,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
          hintText: "e.g. 40",
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    ],
  ),
),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Reset", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Invertiert wie im Screenshot
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // DATEN HOLEN: Text in Zahl umwandeln
                  int newLife = int.tryParse(_lifeController.text) ?? currentStartingLife;
                  
                  // Alles anwenden
                  _setupPlayers(tempPlayerCount, newLife);
                  
                  Navigator.pop(context);
                },
                child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.black,
  body: SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return LayoutTemplates.buildLayout(
          players: players,
          constraints: constraints,
          onUpdate: () => setState(() {}),
        );
      },
    ),
  ),
  // Wir nutzen einen Container, um den Button manuell zu positionieren
  floatingActionButton: Container(
    // margin drückt den Button von den Kanten weg
    // right: 80 verschiebt ihn um ca. 2cm nach links
    margin: const EdgeInsets.only(right: 80.0, bottom: 20.0),
    child: FloatingActionButton(
      backgroundColor: Colors.grey[900]?.withOpacity(0.8),
      onPressed: _showSettingsDialog,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white10, width: 1),
      ),
      child: const Icon(Icons.settings, color: Colors.white, size: 30),
    ),
  ),
  // Optional: Damit der Button nicht durch Standard-Positionen überschrieben wird
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);
}
}