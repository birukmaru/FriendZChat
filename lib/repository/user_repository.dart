/// UserRepository implementation.
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/core/storage/local_storage_service.dart';
import 'package:friendzchat/core/storage/secure_storage_service.dart';
import 'package:friendzchat/data/datasources/user_remote_datasource.dart';
import 'package:friendzchat/data/models/user_dto.dart';
import 'package:friendzchat/domain/entities/user.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserRemoteDataSource remote,
    required SecureStorageService secure,
    required LocalStorageService local,
  })  : _remote = remote,
        _secure = secure,
        _local = local;

  final UserRemoteDataSource _remote;
  final SecureStorageService _secure;
  final LocalStorageService _local;

  // Storage keys for the locally-persisted profile bits. Mirrors what
  // AuthRepositoryImpl writes during register/verifyOtp.
  static const _kNicknameKey = 'private_call.nickname';
  static const _kPhoneKey = 'private_call.phone';
  static const _kBioKey = 'private_call.bio';

  @override
  Future<Result<User>> fetchProfile() async {
    try {
      final dto = await _remote.getProfile();
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<User>> updateProfile(User user) async {
    try {
      // Push to the backend (mock) first.
      final dto = await _remote.updateProfile(UserDto.fromEntity(user));
      // Then persist locally so the edits survive an app restart.
      await _writeOrDelete(_kNicknameKey, dto.nickname);
      await _writeOrDelete(_kPhoneKey, dto.phoneNumber);
      await _writeOrDelete(_kBioKey, dto.bio);
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  Future<void> _writeOrDelete(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await _secure.delete(key);
    } else {
      await _secure.write(key, value);
    }
  }

  @override
  Future<Result<String>> exportUserId() async {
    try {
      final id = await _secure.read('private_call.user_id') ??
          (await _local.getString('private_call.user_id_export'));
      if (id == null) {
        return const Result.failure(AuthFailure('No registered user'));
      }
      return Result.success(id);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> setNickname(String nickname) async {
    try {
      await _secure.write('private_call.nickname', nickname);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> setPhoto(String photoPath) async {
    try {
      await _secure.write('private_call.photo_path', photoPath);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is NetworkException) return NetworkFailure(e.message);
      if (e is ServerException) {
        return ServerFailure(e.message, statusCode: e.statusCode);
      }
      if (e is AuthException) return AuthFailure(e.message);
    }
    return UnknownFailure(e.toString());
  }
}