import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_ai/main.dart';

void main() {
  testWidgets('LEXI AI dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    expect(find.text('LEXI AI  •  LexGuardian Compliance'), findsOneWidget);
    expect(find.text('INICIAR AUDITORÍA'), findsOneWidget);
    expect(find.text('LEXI AI — LexGuardian Compliance'), findsOneWidget);
    expect(find.textContaining('Red de Cumplimiento Inteligente'), findsOneWidget);
  });

  testWidgets('Bottom nav and verdict appear after execution', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    await tester.tap(find.text('INICIAR AUDITORÍA'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('Panel de Control'), findsOneWidget);
    expect(find.text('Command Center'), findsOneWidget);
  });
}
