/// Integration test skeleton — drives the app end-to-end.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:friendzchat/app.dart';
import 'package:friendzchat/dependency_injection/injection.dart';

Future<void> _setUp() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies();
}

void main() {
  testWidgets('App boots and shows splash', (tester) async {
    await _setUp();
    await tester.pumpWidget(const ProviderScope(child: FriendZChatApp()));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('After splash, lands on onboarding (first launch)',
      (tester) async {
    await _setUp();
    await tester.pumpWidget(const ProviderScope(child: FriendZChatApp()));
    // Splash duration ~1.2s.
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle(const Duration(milliseconds: 800));
    expect(find.text('Get started').hitTestable(), findsWidgets);
  });
}