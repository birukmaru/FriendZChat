/// Riverpod providers for in-app notifications.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/domain/entities/app_notification.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => getIt<NotificationRepository>(),
);

class NotificationsNotifier
    extends AutoDisposeAsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    final res = await repo.getNotifications();
    return res.when(
      onSuccess: (list) => list,
      onFailure: (_) => const <AppNotification>[],
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(notificationRepositoryProvider);
      final res = await repo.getNotifications();
      return res.when(
        onSuccess: (list) => list,
        onFailure: (_) => const <AppNotification>[],
      );
    });
  }

  Future<void> markRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markRead(id);
    await refresh();
  }

  Future<void> markAllRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllRead();
    await refresh();
  }

  Future<void> clear() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.clear();
    await refresh();
  }
}

final notificationsProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsNotifier, List<AppNotification>>(NotificationsNotifier.new);