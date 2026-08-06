/// SettingsRepository implementation.
library;

import 'dart:async';

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/core/storage/local_storage_service.dart';
import 'package:friendzchat/core/storage/secure_storage_service.dart';
import 'package:friendzchat/data/datasources/settings_local_datasource.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsLocalDataSource local,
    required SecureStorageService secure,
    required LocalStorageService prefs,
  })  : _local = local,
        _secure = secure,
        _prefs = prefs;

  final SettingsLocalDataSource _local;
  // ignore: unused_field — reserved for secure prefs.
  final SecureStorageService _secure;
  // ignore: unused_field — reserved for direct prefs fallback.
  final LocalStorageService _prefs;

  final StreamController<AppSettings> _controller =
      StreamController<AppSettings>.broadcast();
  AppSettings _cached = const AppSettings();

  @override
  Future<Result<AppSettings>> load() async {
    try {
      final s = await _local.read();
      _cached = s;
      _controller.add(s);
      return Result.success(s);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<AppSettings>> update(AppSettings settings) async {
    try {
      await _local.write(settings);
      _cached = settings;
      _controller.add(settings);
      return Result.success(settings);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<AppThemeMode>> getThemeMode() async {
    final s = await load();
    return s.when(
      onSuccess: (s) => Result.success(s.themeMode),
      onFailure: (f) => Result.failure(f),
    );
  }

  @override
  Future<Result<AppLanguage>> getLanguage() async {
    final s = await load();
    return s.when(
      onSuccess: (s) => Result.success(s.language),
      onFailure: (f) => Result.failure(f),
    );
  }

  @override
  Future<Result<void>> setThemeMode(AppThemeMode mode) async {
    final s = _cached.copyWith(themeMode: mode);
    final result = await update(s);
    return result.when(
      onSuccess: (_) => const Result<void>.success(null),
      onFailure: (f) => Result<void>.failure(f),
    );
  }

  @override
  Future<Result<void>> setLanguage(AppLanguage language) async {
    final s = _cached.copyWith(language: language);
    final result = await update(s);
    return result.when(
      onSuccess: (_) => const Result<void>.success(null),
      onFailure: (f) => Result<void>.failure(f),
    );
  }

  @override
  Stream<AppSettings> watch() => _controller.stream;

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is CacheException) return CacheFailure(e.message);
    }
    return UnknownFailure(e.toString());
  }
}