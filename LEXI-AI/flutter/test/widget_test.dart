import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_ai/main.dart';

void main() {
  testWidgets('LEXI AI dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    expect(find.text('LEXI AI  •  Red de Cumplimiento Inteligente'), findsOneWidget);
    expect(find.text('INICIAR AUDITORÍA'), findsOneWidget);
    expect(find.text('LEXI AI'), findsOneWidget);
    expect(find.text('RegTech • Auditoría Asistida por IA • Blockchain'), findsOneWidget);
  });

  testWidgets('Pipeline execution shows compliance verdict', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiAiApp());
    await tester.tap(find.text('INICIAR AUDITORÍA'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Dictamen de Cumplimiento'), findsOneWidget);
    expect(find.text('CUMPLIMIENTO TOTAL'), findsOneWidget);
  });
}
