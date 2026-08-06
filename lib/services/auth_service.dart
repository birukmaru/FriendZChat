/// Authentication helpers around secure storage.
///
/// Concrete auth providers (Firebase, REST, OTP) plug in here.
library;

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/storage/secure_storage_service.dart';

abstract interface class AuthService {
  Future<String?> readUserId();
  Future<void> writeUserId(String userId);
  Future<void> clear();
  Future<String?> readToken();
  Future<void> writeToken(String token);
}

class AuthServiceImpl implements AuthService {
  AuthServiceImpl({required SecureStorageService secure}) : _secure = secure;

  final SecureStorageService _secure;

  @override
  Future<String?> readUserId() => _secure.read(AppConstants.userIdStorageKey);

  @override
  Future<void> writeUserId(String userId) =>
      _secure.write(AppConstants.userIdStorageKey, userId);

  @override
  Future<void> clear() => _secure.delete(AppConstants.userIdStorageKey);

  @override
  Future<String?> readToken() => _secure.read(AppConstants.authTokenStorageKey);

  @override
  Future<void> writeToken(String token) =>
      _secure.write(AppConstants.authTokenStorageKey, token);
}