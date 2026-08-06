/// In-app notifications list screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/domain/entities/app_notification.dart';
import 'package:friendzchat/presentation/providers/notifications_provider.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';
import 'package:friendzchat/presentation/widgets/shimmer_box.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifs = ref.watch(notificationsProvider);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeader(
            eyebrow: 'Inbox',
            title: 'Notifications',
            subtitle: 'Reminders, tips and product updates.',
            trailing: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.done_all_rounded),
                  tooltip: 'Mark all read',
                  onPressed: () =>
                      ref.read(notificationsProvider.notifier).markAllRead(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded),
                  tooltip: 'Clear',
                  onPressed: () =>
                      ref.read(notificationsProvider.notifier).clear(),
                ),
              ],
            ),
          ),
        ),
        notifs.when(
          data: (list) {
            if (list.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyStateView(
                  icon: Icons.notifications_off_rounded,
                  title: 'No notifications',
                  message:
                      'Reminders, tips and updates will appear here when they arrive.',
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.s,
                AppSpacing.l,
                AppSpacing.huge,
              ),
              sliver: SliverList.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.s),
                itemBuilder: (_, i) => _NotificationCard(item: list[i]),
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: ShimmerListPlaceholder(),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Text('$e'),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.item});
  final AppNotification item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icon = _iconFor(item.kind);
    final color = _colorFor(item.kind, theme);
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.l),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            ref.read(notificationsProvider.notifier).markRead(item.id),
        child: Container(
          decoration: BoxDecoration(
            color: item.isRead
                ? scheme.surface
                : scheme.primaryContainer.withValues(alpha: 0.35),
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      item.createdAt.relative(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(AppNotificationKind k) => switch (k) {
        AppNotificationKind.reminder => Icons.alarm_rounded,
        AppNotificationKind.tip => Icons.lightbulb_rounded,
        AppNotificationKind.update => Icons.system_update_rounded,
        AppNotificationKind.alert => Icons.warning_rounded,
        AppNotificationKind.marketing => Icons.campaign_rounded,
      };

  Color _colorFor(AppNotificationKind k, ThemeData t) => switch (k) {
        AppNotificationKind.reminder => t.colorScheme.primary,
        AppNotificationKind.tip => t.colorScheme.tertiary,
        AppNotificationKind.update => t.colorScheme.secondary,
        AppNotificationKind.alert => t.colorScheme.error,
        AppNotificationKind.marketing => t.colorScheme.onSurfaceVariant,
      };
}