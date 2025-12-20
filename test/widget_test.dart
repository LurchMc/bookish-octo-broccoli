import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtg_life_counter/main.dart';

void main() {
  testWidgets('MTG Life Counter: Startzustand und Interaktion', (WidgetTester tester) async {
    // App laden
    await tester.pumpWidget(const MagicLifeCounterApp());

    // 1. Check: Sind die Texte da?
    // Wir nutzen hier 'find.textContaining', das ist weniger fehleranfällig
    expect(find.textContaining('1'), findsOneWidget);
    expect(find.textContaining('2'), findsOneWidget);
    expect(find.text('40'), findsNWidgets(2));

    // 2. Check: Die Rotation
    expect(find.byType(RotatedBox), findsNWidgets(2));

    // 3. Interaktion: Den Plus-Button finden
    // Wir suchen nach allen Widgets, die ein 'add' Icon haben.
    // Da Icons im Test manchmal schwer zu greifen sind, 
    // suchen wir stattdessen nach dem GestureDetector, der das Icon enthält.
    final plusButtons = find.byIcon(Icons.add);
    
    // Prüfen, ob wir überhaupt Buttons gefunden haben, bevor wir klicken!
    expect(plusButtons, findsNWidgets(2));

    // Jetzt auf den ersten Plus-Button klicken
    await tester.tap(plusButtons.first);
    
    // WICHTIG: Frame neu zeichnen
    await tester.pump();

    // 4. Ergebnis prüfen
    expect(find.text('41'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
  });
}