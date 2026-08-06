/// Local push notifications service.
///
/// Wraps `flutter_local_notifications` so features stay decoupled from the
/// underlying plugin.
library;

import 'package:friendzchat/core/storage/hive_storage_service.dart';
import 'package:friendzchat/domain/entities/app_notification.dart';

abstract interface class NotificationService {
  Future<void> showLocal(AppNotification notification);
  Future<void> cancel(String id);
  Future<void> cancelAll();
  Future<List<AppNotification>> queued();
}

class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl({required HiveStorageService hive}) : _hive = hive;

  final HiveStorageService _hive;

  @override
  Future<void> showLocal(AppNotification notification) async {
    // Real implementation would call flutter_local_notifications here.
    // Keeping the call site so consumers don't depend on the plugin.
  }

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<List<AppNotification>> queued() async => const [];
}