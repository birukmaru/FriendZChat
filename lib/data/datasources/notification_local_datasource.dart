/// Local Hive-backed notification data source.
library;

import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/storage/hive_storage_service.dart';
import 'package:friendzchat/data/models/app_notification_dto.dart';

abstract interface class NotificationLocalDataSource {
  Future<List<AppNotificationDto>> getAll();
  Future<AppNotificationDto> save(AppNotificationDto dto);
  Future<void> delete(String id);
  Future<void> clear();
  Stream<List<AppNotificationDto>> watch();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  NotificationLocalDataSourceImpl({required HiveStorageService hive})
      : _hive = hive;

  final HiveStorageService _hive;

  Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(AppConstants.notificationsBox)) {
      return Hive.box<dynamic>(AppConstants.notificationsBox);
    }
    return Hive.openBox<dynamic>(AppConstants.notificationsBox);
  }

  Future<List<AppNotificationDto>> _readAll() async {
    try {
      final box = await _box();
      final list = box.values
          .whereType<String>()
          .map(jsonDecode)
          .cast<Map<String, dynamic>>()
          .map(AppNotificationDto.fromJson)
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw CacheException('Failed to read notifications', cause: e);
    }
  }

  @override
  Future<List<AppNotificationDto>> getAll() => _readAll();

  @override
  Future<AppNotificationDto> save(AppNotificationDto dto) async {
    try {
      final box = await _box();
      await box.put(dto.id, jsonEncode(dto.toJson()));
      return dto;
    } catch (e) {
      throw CacheException('Failed to save notification', cause: e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final box = await _box();
      await box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete notification', cause: e);
    }
  }

  @override
  Future<void> clear() async {
    try {
      final box = await _box();
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear notifications', cause: e);
    }
  }

  @override
  Stream<List<AppNotificationDto>> watch() async* {
    yield await _readAll();
    yield* _hive
        .watch(AppConstants.notificationsBox)
        .asyncMap((_) => _readAll());
  }
}