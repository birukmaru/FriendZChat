/// Unit tests for [Result].
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/utils/result.dart';

void main() {
  group('Result', () {
    test('success carries the value', () {
      const r = Result<int>.success(42);
      expect(r.isSuccess, isTrue);
      expect(r.valueOrNull, 42);
      expect(r.failureOrNull, isNull);
    });

    test('failure carries the failure', () {
      const f = NetworkFailure('offline');
      const r = Result<int>.failure(f);
      expect(r.isFailure, isTrue);
      expect(r.failureOrNull, f);
      expect(r.valueOrNull, isNull);
    });

    test('when dispatches correctly', () {
      const ok = Result<int>.success(1);
      final v = ok.when(
        onSuccess: (v) => 'ok:$v',
        onFailure: (_) => 'fail',
      );
      expect(v, 'ok:1');

      const fail = Result<int>.failure(NetworkFailure());
      final v2 = fail.when(
        onSuccess: (v) => 'ok:$v',
        onFailure: (f) => 'fail:${f.message}',
      );
      expect(v2, startsWith('fail:'));
    });

    test('unwrap returns the value on success', () {
      const r = Result<int>.success(7);
      expect(r.unwrap(), 7);
    });

    test('unwrapOr returns fallback on failure', () {
      const r = Result<int>.failure(NetworkFailure());
      expect(r.unwrapOr((_) => 99), 99);
    });
  });
}