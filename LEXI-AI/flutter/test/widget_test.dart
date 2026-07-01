import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_ai/main.dart';

void main() {
  testWidgets('LEXI AI dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    expect(find.text('LEXI AI // Intelligent Legal Network'), findsOneWidget);
    expect(find.text('INITIALIZE PIPELINE'), findsOneWidget);
    expect(find.text('LEXI AI'), findsOneWidget);
  });

  testWidgets('Pipeline execution shows tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    await tester.tap(find.text('INITIALIZE PIPELINE'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Compliance Verdict'), findsOneWidget);
    expect(find.text('SHA-256 AUDIT HASH'), findsOneWidget);
    expect(find.text('Audit Trail'), findsOneWidget);
  });
}
