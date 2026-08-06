/// Local settings storage backed by SharedPreferences.
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/storage/local_storage_service.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppSettings> read();
  Future<void> write(AppSettings s);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl({required LocalStorageService local})
      : _local = local;

  final LocalStorageService _local;

  static const _themeKey = 'private_call.theme_mode';
  static const _languageKey = 'private_call.language';
  static const _notifKey = 'private_call.notifications_enabled';
  static const _regRemindersKey = 'private_call.reg_reminders';
  static const _tipsKey = 'private_call.tips_enabled';
  static const _updatesKey = 'private_call.updates_enabled';
  static const _bioLockKey = 'private_call.biometric_lock';

  @override
  Future<AppSettings> read() async {
    try {
      return AppSettings(
        themeMode: _decodeTheme(await _local.getString(_themeKey)),
        language: _decodeLanguage(await _local.getString(_languageKey)),
        notificationsEnabled: (await _local.getBool(_notifKey)) ?? true,
        registrationRemindersEnabled:
            (await _local.getBool(_regRemindersKey)) ?? true,
        tipsEnabled: (await _local.getBool(_tipsKey)) ?? true,
        updatesEnabled: (await _local.getBool(_updatesKey)) ?? true,
        biometricLockEnabled: (await _local.getBool(_bioLockKey)) ?? false,
      );
    } catch (e) {
      throw CacheException('Failed to load settings', cause: e);
    }
  }

  @override
  Future<void> write(AppSettings s) async {
    try {
      await _local.setString(_themeKey, s.themeMode.name);
      await _local.setString(_languageKey, s.language.code);
      await _local.setBool(_notifKey, s.notificationsEnabled);
      await _local.setBool(_regRemindersKey, s.registrationRemindersEnabled);
      await _local.setBool(_tipsKey, s.tipsEnabled);
      await _local.setBool(_updatesKey, s.updatesEnabled);
      await _local.setBool(_bioLockKey, s.biometricLockEnabled);
    } catch (e) {
      throw CacheException('Failed to save settings', cause: e);
    }
  }

  AppThemeMode _decodeTheme(String? raw) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemeMode.system,
    );
  }

  AppLanguage _decodeLanguage(String? raw) {
    return AppLanguage.values.firstWhere(
      (e) => e.code == raw,
      orElse: () => AppLanguage.english,
    );
  }
}
