/// Widget tests for shared widgets.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/error_state_view.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton shows label and reacts to taps', (tester) async {
    int taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PrimaryButton(label: 'Go', onPressed: () => taps++),
      ),
    ));
    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Go'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('PrimaryButton is disabled while busy', (tester) async {
    int taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
          label: 'Go',
          busy: true,
          onPressed: () => taps++,
        ),
      ),
    ));
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    expect(taps, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('EmptyStateView renders title and CTA', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EmptyStateView(
          title: 'Nothing here',
          actionLabel: 'Add',
          onAction: () {},
        ),
      ),
    ));
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('ErrorStateView shows retry button', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ErrorStateView(
          message: 'oops',
          onRetry: () {},
        ),
      ),
    ));
    expect(find.text('oops'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}