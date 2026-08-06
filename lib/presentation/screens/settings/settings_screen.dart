/// Settings screen — main entry.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/core/strings/strings.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';
import 'package:friendzchat/presentation/widgets/stat_tile.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prefs = ref.watch(prefsStateProvider);
    final auth = ref.watch(authStateProvider);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeader(
            eyebrow: context.strings['settings.eyebrow'],
            title: context.strings['settings.title'],
            subtitle: context.strings['settings.subtitle'],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.huge,
          ),
          sliver: SliverList.list(
            children: [
              _Section(
                title: context.strings['settings.section.profile'],
                children: [
                  _Card(
                    children: [
                      StatTile(
                        icon: Icons.account_circle_rounded,
                        label: context.strings['settings.profile.view'],
                        subtitle: auth.user?.nickname ?? 'Your account',
                        onTap: () => context.push(AppRoutes.profile),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: context.strings['settings.section.preferences'],
                children: [
                  _Card(
                    children: [
                      _SwitchTile(
                        icon: Icons.dark_mode_rounded,
                        title: context
                            .strings['settings.preferences.theme.title'],
                        subtitle: _themeLabel(prefs.themeMode),
                        value: prefs.themeMode == AppThemeMode.dark,
                        onChanged: (v) {
                          ref.read(prefsStateProvider.notifier).setThemeMode(
                              v ? AppThemeMode.dark : AppThemeMode.light);
                        },
                      ),
                      _Divider(),
                      _SwitchTile(
                        icon: Icons.notifications_rounded,
                        title: context.strings[
                            'settings.preferences.notifications.title'],
                        subtitle: context.strings[
                            'settings.preferences.notifications.subtitle'],
                        value: prefs.notificationsEnabled,
                        onChanged: (v) => ref
                            .read(prefsStateProvider.notifier)
                            .setNotificationsEnabled(v),
                      ),
                      _Divider(),
                      StatTile(
                        icon: Icons.translate_rounded,
                        label: context
                            .strings['settings.preferences.language.title'],
                        value: prefs.language.displayName,
                        onTap: () =>
                            context.push(AppRoutes.settingsLanguage),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: context.strings['settings.section.support'],
                children: [
                  _Card(
                    children: [
                      StatTile(
                        icon: Icons.help_rounded,
                        label: 'Help center',
                        onTap: () =>
                            context.push(AppRoutes.settingsHelp),
                      ),
                      _Divider(),
                      StatTile(
                        icon: Icons.support_agent_rounded,
                        label: 'Contact support',
                        onTap: () =>
                            context.push(AppRoutes.settingsSupport),
                      ),
                      _Divider(),
                      StatTile(
                        icon: Icons.quiz_rounded,
                        label: 'FAQ',
                        onTap: () =>
                            context.push(AppRoutes.settingsFaq),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: context.strings['settings.section.legal'],
                children: [
                  _Card(
                    children: [
                      StatTile(
                        icon: Icons.privacy_tip_rounded,
                        label: 'Privacy policy',
                        onTap: () =>
                            context.push(AppRoutes.settingsPrivacy),
                      ),
                      _Divider(),
                      StatTile(
                        icon: Icons.gavel_rounded,
                        label: 'Terms of service',
                        onTap: () =>
                            context.push(AppRoutes.settingsTerms),
                      ),
                      _Divider(),
                      StatTile(
                        icon: Icons.info_rounded,
                        label: 'About',
                        subtitle: 'Version & credits',
                        onTap: () =>
                            context.push(AppRoutes.settingsAbout),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _Card(
                children: [
                  StatTile(
                    icon: Icons.logout_rounded,
                    label: context.strings['settings.signout'],
                    subtitle: context.strings['settings.signout.subtitle'],
                    danger: true,
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          icon: const Icon(Icons.logout_rounded),
                          title: const Text('Sign out?'),
                          content: const Text(
                            'You will need your FriendZChat ID to sign back in.',
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
                              child: const Text('Sign out'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await ref
                            .read(authStateProvider.notifier)
                            .logout();
                        if (!context.mounted) return;
                        context.go(AppRoutes.register);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Center(
                child: Text(
                  auth.user?.id ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }

  String _themeLabel(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => 'Match system',
        AppThemeMode.light => 'Always light',
        AppThemeMode.dark => 'Always dark',
      };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s,
              AppSpacing.l,
              AppSpacing.s,
              AppSpacing.s,
            ),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppSpacing.l + 44 + AppSpacing.l,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: scheme.primary),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}