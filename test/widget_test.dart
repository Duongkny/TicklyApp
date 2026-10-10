
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickly/main.dart';

void main() {
  testWidgets('Tickly application smoke test', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tickly'), findsOneWidget);
    expect(find.text('Welcome to Tickly!'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
