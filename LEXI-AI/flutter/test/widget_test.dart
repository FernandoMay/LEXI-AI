import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_ai/main.dart';

void main() {
  testWidgets('App renders brand', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    expect(find.text('LEXI AI  •  LexGuardian Compliance'), findsOneWidget);
    expect(find.text('LEXI AI — LexGuardian Compliance'), findsOneWidget);
    expect(find.textContaining('Red de Cumplimiento Inteligente'), findsOneWidget);
    // Let auto-pipeline timer complete so test framework doesn't complain
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
  });

  testWidgets('Auto-execution shows dashboard after pipeline completes', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    await tester.pump(); // processing=true
    await tester.pump(const Duration(milliseconds: 900)); // timer fires
    await tester.pump(); // rebuild with report loaded
    expect(find.text('Command Center'), findsOneWidget);
    expect(find.text('Panel de Control'), findsOneWidget);
  });
}
