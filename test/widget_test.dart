// This is a basic Flutter widget test for the Calculator app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:calculator/main.dart';
import 'package:calculator/providers/calculator_provider.dart';
import 'package:calculator/providers/history_provider.dart';

void main() {
  testWidgets('Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CalculatorProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the calculator starts with empty display
    expect(find.text('Calculator'), findsOneWidget);

    // Find and tap the '2' button
    await tester.tap(find.text('2'));
    await tester.pump();

    // Find and tap the '+' button
    await tester.tap(find.text('+'));
    await tester.pump();

    // Find and tap the '3' button
    await tester.tap(find.text('3'));
    await tester.pump();

    // Find and tap the '=' button
    await tester.tap(find.text('='));
    await tester.pump();

    // Verify that the result shows '5'
    expect(find.text('5'), findsOneWidget);

    // Verify that the expression '2+3' is still visible (our new behavior)
    expect(find.text('2+3'), findsOneWidget);
  });

  testWidgets('Scientific mode toggle test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CalculatorProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Tap the scientific mode toggle button
    await tester.tap(find.byIcon(Icons.functions));
    await tester.pump();

    // Verify that scientific functions are now available
    expect(find.text('sin'), findsOneWidget);
    expect(find.text('cos'), findsOneWidget);
    expect(find.text('tan'), findsOneWidget);
  });
}
