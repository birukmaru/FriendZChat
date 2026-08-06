/// History screen — full call log with swipe-to-delete.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/presentation/providers/history_provider.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';
import 'package:friendzchat/presentation/widgets/shimmer_box.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeader(
            eyebrow: 'Activity',
            title: 'Call history',
            subtitle: 'Every call, every direction.',
            trailing: IconButton(
              tooltip: 'Clear all',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    icon: const Icon(Icons.delete_sweep_rounded),
                    title: const Text('Clear history?'),
                    content: const Text(
                      'This will remove every call record on this device.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () =>
                            Navigator.of(context).pop(true),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref.read(historyProvider.notifier).clear();
                }
              },
            ),
          ),
        ),
        history.when(
          data: (list) {
            if (list.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyStateView(
                  icon: Icons.history_toggle_off_rounded,
                  title: 'No history yet',
                  message:
                      'Once you place your first call, it will appear here.',
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
                itemBuilder: (_, i) => _HistoryCard(record: list[i]),
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

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.record});
  final CallRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final missed = record.isMissed;
    final color = missed ? scheme.error : scheme.primary;

    return Dismissible(
      key: ValueKey(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        child: Icon(
          Icons.delete_rounded,
          color: scheme.onErrorContainer,
        ),
      ),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.callTo(record.remoteUserId)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppRadius.l),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    ContactAvatar(
                      name: record.remoteName,
                      size: 48,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.surface,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          missed
                              ? Icons.call_missed_rounded
                              : Icons.call_made_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.remoteName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${record.startedAt.formatted} • ${record.startedAt.timeFormatted}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  record.duration.callDuration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}