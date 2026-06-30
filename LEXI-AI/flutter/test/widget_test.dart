import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_ai/main.dart';

void main() {
  testWidgets('LEXI AI dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    expect(find.text('LEXI AI // Intelligent Legal Network'), findsOneWidget);
    expect(find.text('EXECUTE COGNITIVE PIPELINE'), findsOneWidget);
    expect(find.text('Legal Document Ingest'), findsOneWidget);
    expect(find.text('Immutable Audit Monitor'), findsOneWidget);
  });

  testWidgets('Pipeline execution updates UI', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    await tester.tap(find.text('EXECUTE COGNITIVE PIPELINE'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('COMPLIANT - ALL RULES VALIDATED'), findsOneWidget);
  });
}
