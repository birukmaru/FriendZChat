/// Tests for use cases — exercising repository contracts via mocks.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/entities/user.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/domain/usecases/usecases.dart';
import 'package:friendzchat/utils/result.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockContactRepo extends Mock implements ContactRepository {}

void main() {
  late _MockAuthRepo auth;
  late _MockContactRepo contacts;

  setUp(() {
    auth = _MockAuthRepo();
    contacts = _MockContactRepo();
  });

  test('buildDialDestination prepends 8776', () {
    expect(buildDialDestination('123456'), '8776123456');
    expect(buildDialDestination('987654'), '${AppConstants.serviceShortCode}987654');
  });

  test('RegisterUser delegates to AuthRepository', () async {
    when(() => auth.register(
          userId: any(named: 'userId'),
          nickname: any(named: 'nickname'),
          phoneNumber: any(named: 'phoneNumber'),
        )).thenAnswer((_) async => Result.success(
          const User(id: '123456', nickname: 'Ada'),
        ));
    final result = await RegisterUser(auth).call(
      userId: '123456',
      nickname: 'Ada',
    );
    expect(result.isSuccess, isTrue);
    verify(() => auth.register(
          userId: '123456',
          nickname: 'Ada',
          phoneNumber: null,
        )).called(1);
  });

  test('ListContacts returns list', () async {
    when(() => contacts.getContacts()).thenAnswer(
      (_) async => Result.success([
        const Contact(id: '1', userId: '111111', name: 'A'),
      ]),
    );
    final r = await ListContacts(contacts).call();
    expect(r.valueOrNull, hasLength(1));
  });
}