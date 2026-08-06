/// Home screen — primary dashboard with user ID, quick actions, recents, favourites.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/providers/contacts_provider.dart';
import 'package:friendzchat/presentation/providers/history_provider.dart';
import 'package:friendzchat/presentation/screens/contacts/contacts_screen.dart';
import 'package:friendzchat/presentation/screens/history/history_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_screen.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/floating_nav_dock.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';
import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;

  static const List<Widget> _tabs = [
    _DashboardTab(),
    ContactsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  static const List<NavSlot> _navSlots = [
    NavSlot(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NavSlot(
      icon: Icons.people_outline,
      selectedIcon: Icons.people_rounded,
      label: 'Contacts',
    ),
    NavSlot(
      icon: Icons.history_rounded,
      selectedIcon: Icons.history_rounded,
      label: 'History',
    ),
    NavSlot(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  void _openAddContact() {
    context.push(AppRoutes.contactsAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _tabs[_tabIndex]),
      bottomNavigationBar: FloatingNavDock(
        slots: _navSlots,
        selectedIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        onAddPressed: _openAddContact,
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final theme = Theme.of(context);
    final user = auth.user;
    final id = user?.id ?? '000000';
    final greeting = _greetingFor();

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          expandedHeight: 320,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGradient,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -60,
                    child: _Glow(
                      size: 220,
                      color: const Color(0xFF17BEBB).withValues(alpha: 0.35),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: _Glow(
                      size: 200,
                      color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.huge,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          greeting.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          user?.nickname ?? 'Friend',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Text(
                          'Your FriendZChat ID',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          id,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Row(
                          children: [
                            _ChipAction(
                              icon: Icons.content_copy_rounded,
                              label: 'Copy',
                              onTap: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: id));
                                if (!context.mounted) return;
                                context.showSnack('ID copied');
                              },
                            ),
                            const SizedBox(width: AppSpacing.s),
                            _ChipAction(
                              icon: Icons.ios_share_rounded,
                              label: 'Share',
                              onTap: () => Share.share(
                                'Add me on FriendZChat — my ID is $id',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: const Text(''),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.l,
            AppSpacing.l,
            AppSpacing.huge,
          ),
          sliver: SliverList.list(
            children: [
              _QuickCallCard(userId: id),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(
                title: 'Favorites',
                subtitle: 'Quick access to the people you call most',
              ),
              _FavoritesPreview(),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(
                title: 'Recent calls',
                subtitle: 'Your last 24 hours of calls',
              ),
              _RecentPreview(),
            ],
          ),
        ),
      ],
    );
  }

  String _greetingFor() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _ChipAction extends StatelessWidget {
  const _ChipAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.s,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickCallCard extends StatelessWidget {
  const _QuickCallCard({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick call',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to enter a FriendZChat ID and dial',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(AppRoutes.call),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.s),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.medium)
        .slideY(begin: 0.1, end: 0);
  }
}

class _FavoritesPreview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    return contacts.when(
      data: (list) {
        final favs = list.where((c) => c.isFavorite).take(6).toList();
        if (favs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
            child: EmptyStateView(
              icon: Icons.star_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the star on a contact to keep them handy here.',
              actionLabel: 'Add contact',
              onAction: () => context.push(AppRoutes.contactsAdd),
            ),
          );
        }
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            itemCount: favs.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
            itemBuilder: (_, i) => _FavoriteTile(contact: favs[i]),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.callTo(contact.userId)),
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            Stack(
              children: [
                ContactAvatar(
                  name: contact.name,
                  photoUrl: contact.photoUrl,
                  size: 64,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.call_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              contact.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentPreview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return history.when(
      data: (list) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
            child: EmptyStateView(
              icon: Icons.phone_missed_rounded,
              title: 'No recent calls',
              message: 'Your last 24 hours of calls will appear here.',
            ),
          );
        }
        final recent = list.take(5).toList();
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < recent.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: AppSpacing.l + 56 + AppSpacing.l,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                _RecentTile(record: recent[i]),
              ],
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.record});
  final CallRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = record.isMissed
        ? Icons.call_missed_rounded
        : Icons.call_made_rounded;
    final color = record.isMissed
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        record.remoteName,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        record.startedAt.relative(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        record.duration.callDuration,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      onTap: () => context.push(AppRoutes.callTo(record.remoteUserId)),
    );
  }
}