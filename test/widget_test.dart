import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtg_life_counter/main.dart'; 

void main() {
  testWidgets('MTG Life Counter: Testet dynamisches Layout und Lebenspunkte', (WidgetTester tester) async {
    // 1. Die App laden
    await tester.pumpWidget(const MagicLifeCounterApp());
    // Warten, bis alles stabil steht
    await tester.pumpAndSettle();

    // 2. Prüfung der Startwerte (Annahme: App startet mit 3 Spielern à 40 Leben)
    // Wir prüfen, ob wir mindestens 3-mal die Zahl 40 finden
    expect(find.text('40'), findsNWidgets(3));

    // 3. Prüfen, ob Spielernummern vorhanden sind
    expect(find.textContaining('1'), findsOneWidget);
    expect(find.textContaining('2'), findsOneWidget);
    expect(find.textContaining('3'), findsOneWidget);

   // 4. Lebenspunkte bei Spieler 1 erhöhen
    // Wir suchen nach dem ersten Widget, das ein Plus-Icon sein könnte.
    // Falls Icons.add_circle_outline nicht klappt, versuchen wir Icons.add
    Finder addIconFinder = find.byIcon(Icons.add_circle_outline);
    
    // Falls das nicht gefunden wird, probieren wir das Standard-Plus:
    if (tester.any(find.byIcon(Icons.add))) {
      addIconFinder = find.byIcon(Icons.add);
    } 
    // Falls du Icons.add_circle benutzt:
    else if (tester.any(find.byIcon(Icons.add_circle))) {
      addIconFinder = find.byIcon(Icons.add_circle);
    }

    // Sicherheitscheck: Haben wir IRGENDEIN Plus-Icon gefunden?
    expect(addIconFinder, findsAtLeastNWidgets(1), 
      reason: 'Kein Plus-Icon gefunden. Bitte prüfe in main.dart, ob du Icons.add, Icons.add_circle oder Icons.add_circle_outline nutzt.');

    await tester.tap(addIconFinder.first);
    await tester.pump();

    // Verifizieren: Einer hat 41, die anderen zwei haben noch 40
    expect(find.text('41'), findsOneWidget);
    expect(find.text('40'), findsNWidgets(2)); // Nur noch 2 Spieler haben 40

    // 5. Test der Spieleranzahl-Änderung über das Menü
    // Wir suchen das Gruppen-Icon für die Einstellungen
    final menuIcon = find.byIcon(Icons.groups);
    expect(menuIcon, findsOneWidget);
    
    await tester.tap(menuIcon);
    await tester.pumpAndSettle(); // Warten bis das Popup-Menü offen ist

    // Wir wählen "2 Spieler" aus
    // Hinweis: Der Text muss EXAKT so im PopupMenuItem stehen
    final twoPlayerOption = find.text('2 Spieler');
    expect(twoPlayerOption, findsOneWidget);
    
    await tester.tap(twoPlayerOption);
    await tester.pumpAndSettle(); // Warten bis das Layout gewechselt hat

    // Verifizieren: Jetzt dürfen nur noch 2 Spieler-Widgets existieren
    expect(find.textContaining('1'), findsOneWidget);
    expect(find.textContaining('2'), findsOneWidget);
    expect(find.textContaining('3'), findsNothing); // Spieler 3 muss verschwunden sein
  });
}