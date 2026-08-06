/// AuthRepository implementation.
library;

import '../core/errors/exceptions.dart';
import '../core/errors/failures.dart';
import '../core/network/network_info.dart';
import '../core/storage/secure_storage_service.dart';
import '../data/datasources/user_remote_datasource.dart';
import '../data/models/user_dto.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/repositories.dart';
import '../services/auth_service.dart';
import '../utils/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required UserRemoteDataSource remote,
    required SecureStorageService secure,
    required AuthService authService,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _secure = secure,
        _auth = authService,
        _networkInfo = networkInfo;

  final UserRemoteDataSource _remote;
  final SecureStorageService _secure;
  final AuthService _auth;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final id = await _auth.readUserId();
      if (id == null) return const Result.success(null);
      final dto = UserDto(
        id: id,
        nickname: await _secure.read('private_call.nickname'),
        phoneNumber: await _secure.read('private_call.phone'),
        bio: await _secure.read('private_call.bio'),
        createdAt: DateTime.now(),
      );
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<User>> register({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) async {
    try {
      await validateUserId(userId);
      if (!await _networkInfo.isConnected) {
        throw const NetworkException('No internet connection');
      }
      final dto = await _remote.register(
        userId: userId,
        nickname: nickname,
        phoneNumber: phoneNumber,
      );
      await _auth.writeUserId(dto.id);
      if (dto.nickname != null) {
        await _secure.write('private_call.nickname', dto.nickname!);
      }
      if (dto.phoneNumber != null) {
        await _secure.write('private_call.phone', dto.phoneNumber!);
      }
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> validateUserId(String userId) async {
    if (!RegExp(r'^\d{6}$').hasMatch(userId.trim())) {
      return const Result.failure(
        ValidationFailure('Enter a valid 6-digit FriendZChat ID'),
      );
    }
    return const Result.success(null);
  }

  @override
  Future<Result<bool>> isRegistered() async {
    try {
      final id = await _auth.readUserId();
      return Result.success(id != null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _auth.clear();
      await _secure.delete('private_call.nickname');
      await _secure.delete('private_call.phone');
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> requestOtp(String phoneNumber) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw const NetworkException('No internet connection');
      }
      await _remote.requestOtp(phoneNumber);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<User>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw const NetworkException('No internet connection');
      }
      final dto = await _remote.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      await _auth.writeUserId(dto.id);
      if (dto.phoneNumber != null) {
        await _secure.write('private_call.phone', dto.phoneNumber!);
      }
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is NetworkException) return NetworkFailure(e.message);
      if (e is ServerException) {
        return ServerFailure(
          e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        );
      }
      if (e is AuthException) return AuthFailure(e.message);
      if (e is CacheException) return CacheFailure(e.message);
      if (e is ValidationException) return ValidationFailure(e.message);
      if (e is CancelledException) return CancelledFailure(e.message);
      if (e is PermissionDeniedException) {
        return PermissionDeniedFailure(e.message);
      }
    }
    return UnknownFailure(e.toString());
  }
}
