/// Placeholder widget test kept to satisfy the default `flutter test`
/// entrypoint. Real widget tests live under `test/widgets/`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('trivially renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}