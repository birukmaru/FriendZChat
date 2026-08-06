/// NotificationRepository implementation.
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/data/datasources/notification_local_datasource.dart';
import 'package:friendzchat/data/models/app_notification_dto.dart';
import 'package:friendzchat/domain/entities/app_notification.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/services/notification_service.dart';
import 'package:friendzchat/utils/result.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationLocalDataSource local,
    required NotificationService notificationService,
  })  : _local = local,
        _service = notificationService;

  final NotificationLocalDataSource _local;
  final NotificationService _service;

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      final dtos = await _local.getAll();
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> add(AppNotification notification) async {
    try {
      await _local.save(AppNotificationDto.fromEntity(notification));
      await _service.showLocal(notification);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> markRead(String id) async {
    try {
      final list = await _local.getAll();
      final target = list.firstWhere((n) => n.id == id);
      await _local.save(target.copyWith(isRead: true));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> markAllRead() async {
    try {
      final list = await _local.getAll();
      for (final n in list) {
        if (!n.isRead) {
          await _local.save(n.copyWith(isRead: true));
        }
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> clear() async {
    try {
      await _local.clear();
      await _service.cancelAll();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Stream<List<AppNotification>> watchNotifications() => _local
      .watch()
      .map((dtos) => dtos.map((d) => d.toEntity()).toList());

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is CacheException) return CacheFailure(e.message);
    }
    return UnknownFailure(e.toString());
  }
}