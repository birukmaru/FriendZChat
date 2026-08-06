/// Tests for domain entities.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/entities/user.dart';

void main() {
  group('User', () {
    test('displayName falls back to ID', () {
      const u = User(id: '123456');
      expect(u.displayName, 'User 123456');
    });
    test('displayName prefers nickname', () {
      const u = User(id: '123456', nickname: 'Ada');
      expect(u.displayName, 'Ada');
    });
    test('initial uses first letter of nickname', () {
      const u = User(id: '123456', nickname: 'Ada');
      expect(u.initial, 'A');
    });
    test('initial uses first letter of id when no nickname', () {
      const u = User(id: '123456');
      expect(u.initial, '1');
    });
    test('copyWith updates fields', () {
      const u = User(id: '123456');
      final updated = u.copyWith(nickname: 'Ada', isVerified: true);
      expect(updated.nickname, 'Ada');
      expect(updated.isVerified, isTrue);
      expect(updated.id, '123456');
    });
  });

  group('Contact', () {
    test('dialDestination prepends service number', () {
      const c = Contact(id: '1', userId: '123456', name: 'A');
      expect(c.dialDestination, '8776123456');
    });
    test('copyWith toggles favorite', () {
      const c = Contact(id: '1', userId: '123456', name: 'A');
      final updated = c.copyWith(isFavorite: true);
      expect(updated.isFavorite, isTrue);
    });
  });

  group('CallRecord', () {
    final ts = DateTime.fromMillisecondsSinceEpoch(0);

    test('dialDestination prepends service number', () {
      final r = CallRecord(
        id: 'x',
        remoteUserId: '123456',
        remoteName: 'A',
        startedAt: ts,
      );
      expect(r.dialDestination, '8776123456');
    });

    test('isMissed when status is missed', () {
      final r = CallRecord(
        id: 'x',
        remoteUserId: '1',
        remoteName: 'A',
        startedAt: ts,
        status: CallStatus.missed,
      );
      expect(r.isMissed, isTrue);
    });

    test('isMissed false for completed outgoing', () {
      final r = CallRecord(
        id: 'x',
        remoteUserId: '1',
        remoteName: 'A',
        startedAt: ts,
      );
      expect(r.isMissed, isFalse);
    });
  });
}