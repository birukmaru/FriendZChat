/// Local non-sensitive settings storage (theme, locale, onboarding flag, etc.).
library;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:friendzchat/utils/logger.dart';

/// Thin abstraction over `SharedPreferences` for non-sensitive settings.
abstract interface class LocalStorageService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);
  Future<double?> getDouble(String key);
  Future<void> setDouble(String key, double value);
  Future<List<String>?> getStringList(String key);
  Future<void> setStringList(String key, List<String> values);
  Future<void> remove(String key);
  Future<void> clearAll();
}

class LocalStorageServiceImpl implements LocalStorageService {
  LocalStorageServiceImpl(this._prefs);

  final SharedPreferences _prefs;

  /// Builds a service backed by a freshly loaded instance.
  static Future<LocalStorageServiceImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageServiceImpl(prefs);
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e, st) {
      AppLogger.e('LocalStorage getString failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e, st) {
      AppLogger.e('LocalStorage setString failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<double?> getDouble(String key) async => _prefs.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async =>
      _prefs.getStringList(key);

  @override
  Future<void> setStringList(String key, List<String> values) async {
    await _prefs.setStringList(key, values);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}