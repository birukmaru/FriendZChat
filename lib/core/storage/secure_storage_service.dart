/// Secure storage facade for sensitive data (user ID, auth tokens, etc.).
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:friendzchat/utils/logger.dart';

/// Wraps `flutter_secure_storage` with a thin, typed API.
abstract interface class SecureStorageService {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clearAll();
  Future<bool> contains(String key);
}

/// Default production implementation — uses platform keychain / keystore.
class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
                resetOnError: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, st) {
      AppLogger.e('SecureStorage read failed for $key', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, st) {
      AppLogger.e('SecureStorage write failed for $key', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, st) {
      AppLogger.e('SecureStorage delete failed for $key', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, st) {
      AppLogger.e('SecureStorage clearAll failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<bool> contains(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, st) {
      AppLogger.e('SecureStorage contains failed for $key', error: e, stackTrace: st);
      return false;
    }
  }
}