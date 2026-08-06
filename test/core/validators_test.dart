/// Unit tests for [Validators].
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:friendzchat/core/constants/service_constants.dart';

void main() {
  group('Validators.isUserId', () {
    test('accepts a 6-digit numeric string', () {
      expect(Validators.isUserId('123456'), isTrue);
    });

    test('rejects strings with non-digits', () {
      expect(Validators.isUserId('12345a'), isFalse);
    });

    test('rejects too-short strings', () {
      expect(Validators.isUserId('12345'), isFalse);
    });

    test('rejects too-long strings', () {
      expect(Validators.isUserId('1234567'), isFalse);
    });

    test('rejects null', () {
      expect(Validators.isUserId(null), isFalse);
    });
  });

  group('Validators.isPhoneNumber', () {
    test('accepts E.164 numbers', () {
      expect(Validators.isPhoneNumber('+14155552671'), isTrue);
    });
    test('accepts national-format numbers', () {
      expect(Validators.isPhoneNumber('(415) 555-2671'), isTrue);
    });
    test('rejects letters', () {
      expect(Validators.isPhoneNumber('hello'), isFalse);
    });
  });

  group('FormValidators.userId', () {
    test('rejects empty', () {
      expect(FormValidators.userId()(null), isNotNull);
      expect(FormValidators.userId()(''), isNotNull);
    });
    test('rejects wrong length', () {
      expect(FormValidators.userId()('12345'), isNotNull);
    });
    test('passes valid', () {
      expect(FormValidators.userId()('123456'), isNull);
    });
  });
}