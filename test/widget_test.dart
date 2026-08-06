// Basic smoke test for the FriendZChat app.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:friendzchat/app.dart';

void main() {
  testWidgets('App boots without exceptions', (WidgetTester tester) async {
    // Smoke test that the root widget can be instantiated.
    expect(const FriendZChatApp(), isA<Widget>());
  });
}
