/// Repository tests with mocked data sources.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/core/network/network_info.dart';
import 'package:friendzchat/core/storage/secure_storage_service.dart';
import 'package:friendzchat/data/datasources/contact_local_datasource.dart';
import 'package:friendzchat/data/datasources/user_remote_datasource.dart';
import 'package:friendzchat/data/models/contact_dto.dart';
import 'package:friendzchat/data/models/user_dto.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/repository/auth_repository.dart';
import 'package:friendzchat/repository/contact_repository.dart';
import 'package:friendzchat/services/auth_service.dart';
import 'package:friendzchat/utils/result.dart';

class _MockSecure extends Mock implements SecureStorageService {}

class _MockAuthService extends Mock implements AuthService {}

class _MockNetwork extends Mock implements NetworkInfo {}

class _MockRemote extends Mock implements UserRemoteDataSource {}

class _MockContactLocal extends Mock implements ContactLocalDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late _MockSecure secure;
    late _MockAuthService auth;
    late _MockNetwork network;
    late _MockRemote remote;
    late AuthRepositoryImpl repo;

    setUpAll(() {
      registerFallbackValue('');
    });

    setUp(() {
      secure = _MockSecure();
      auth = _MockAuthService();
      network = _MockNetwork();
      remote = _MockRemote();
      repo = AuthRepositoryImpl(
        secure: secure,
        authService: auth,
        networkInfo: network,
        remote: remote,
      );
    });

    test('register succeeds and stores id', () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remote.register(
            userId: any(named: 'userId'),
            nickname: any(named: 'nickname'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async => const UserDto(
            id: '123456',
            nickname: 'Ada',
          ));
      when(() => auth.writeUserId(any())).thenAnswer((_) async {});

      final res = await repo.register(
        userId: '123456',
        nickname: 'Ada',
      );

      expect(res.isSuccess, isTrue);
      verify(() => auth.writeUserId('123456')).called(1);
    });

    test('register fails when offline', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      final res = await repo.register(userId: '123456');
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull, isA<NetworkFailure>());
    });

    test('validateUserId rejects invalid input', () async {
      final res = await repo.validateUserId('abc');
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull, isA<ValidationFailure>());
    });

    test('validateUserId accepts valid input', () async {
      final res = await repo.validateUserId('123456');
      expect(res.isSuccess, isTrue);
    });
  });

  group('ContactRepositoryImpl', () {
    late _MockContactLocal local;
    late _MockRemote remote;
    late ContactRepositoryImpl repo;

    setUp(() {
      local = _MockContactLocal();
      remote = _MockRemote();
      repo = ContactRepositoryImpl(local: local, remote: remote);
    });

    test('addContact delegates to local', () async {
      when(() => local.save(any())).thenAnswer((inv) async {
        return inv.positionalArguments.first as ContactDto;
      });
      final res = await repo.addContact(
        const Contact(id: '1', userId: '123456', name: 'A'),
      );
      expect(res.isSuccess, isTrue);
      verify(() => local.save(any())).called(1);
    });

    test('toggleFavorite inverts flag', () async {
      when(() => local.getById('1')).thenAnswer(
        (_) async => const ContactDto(
          id: '1',
          userId: '123456',
          name: 'A',
          isFavorite: false,
        ),
      );
      when(() => local.save(any())).thenAnswer((inv) async {
        return inv.positionalArguments.first as ContactDto;
      });
      final res = await repo.toggleFavorite('1');
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull?.isFavorite, isTrue);
    });

    test('errors surface as UnknownFailure', () async {
      when(() => local.getAll()).thenThrow(Exception('boom'));
      final res = await repo.getContacts();
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull, isA<UnknownFailure>());
    });

    test('CacheException surfaces as CacheFailure', () async {
      when(() => local.getAll()).thenThrow(CacheException('disk full'));
      final res = await repo.getContacts();
      expect(res.failureOrNull, isA<CacheFailure>());
    });
  });
}