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
  int currentStartingLife = 40;
  final TextEditingController _lifeController = TextEditingController(text: '40');

  @override
  void initState() {
    super.initState();
    _setupPlayers(4, 40);
  }

  void _setupPlayers(int count, int startingLife) {
    setState(() {
      currentStartingLife = startingLife;
      players = List.generate(count, (index) => PlayerData(id: index + 1, life: startingLife));
    });
  }

  void _openCommanderDamageDialog(PlayerData targetPlayer) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Cmd Damage an P${targetPlayer.id}", style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: players.where((p) => p.id != targetPlayer.id).map((attacker) {
                int damage = targetPlayer.commanderDamage[attacker.id] ?? 0;
                return ListTile(
                  title: Text("Von P${attacker.id}", style: const TextStyle(color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.remove, color: Colors.red), onPressed: () {
                        setDialogState(() { if(damage > 0) { targetPlayer.commanderDamage[attacker.id] = --damage; targetPlayer.life++; setState((){}); } });
                      }),
                      Text("$damage", style: const TextStyle(color: Colors.amber, fontSize: 20)),
                      IconButton(icon: const Icon(Icons.add, color: Colors.green), onPressed: () {
                        setDialogState(() { targetPlayer.commanderDamage[attacker.id] = ++damage; targetPlayer.life--; setState((){}); });
                      }),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    int tempCount = players.length;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          backgroundColor: Colors.grey[900],
          title: const Text("Settings", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: tempCount,
                isExpanded: true,
                dropdownColor: Colors.black,
                items: [2,3,4,5,6].map((i) => DropdownMenuItem(value: i, child: Text("$i Spieler", style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (v) => setDialogState(() => tempCount = v!),
              ),
              TextField(
                controller: _lifeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Start-Leben", labelStyle: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: () {
              _setupPlayers(tempCount, int.tryParse(_lifeController.text) ?? 40);
              Navigator.pop(context);
            }, child: const Text("Apply"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => LayoutTemplates.buildLayout(
            players: players,
            constraints: constraints,
            onUpdate: () => setState(() {}),
            onLongPressPlayer: _openCommanderDamageDialog,
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 80.0, bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: Colors.grey[900]?.withOpacity(0.8),
          onPressed: _showSettingsDialog,
          child: const Icon(Icons.settings, color: Colors.white),
        ),
      ),
    );
  }
}