// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mtg_life_counter/main.dart';

void main() {
  testWidgets('Lebenspunkte erhöhen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MagicLifeCounterApp());

    // Verify that our counter starts at 40
    // Da Standardmäßig 2 Spieler gegeben sind, erwarten wir die 40 2 mal
    expect(find.text('40'), findsNWidgets(2));

    // Tap the '+' icon and trigger a frame
    // Suche nach das erste Icon mit +-Symbol
    final plusButton = find.byIcon(Icons.add_circle_outline).first;
    await tester.tap(plusButton);

    // Frame neu zeichnen
    await tester.pump();

    // Prüfen, ob jetzt einmal '41' da steht (für Spieler 1)
    // und immer noch einmal '40' (für Spieler 2)
    expect(find.text('40'), findsOneWidget);
    expect(find.text('41'), findsOneWidget);
  });
}
