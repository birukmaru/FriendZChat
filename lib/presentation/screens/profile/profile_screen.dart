/// Profile screen — view / edit current user.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = auth.user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No profile')));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit profile',
            onPressed: () => context.push(AppRoutes.profileEdit),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.huge,
          ),
          children: [
            Center(
              child: Column(
                children: [
                  if (user.photoUrl != null)
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user.photoUrl!,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    ContactAvatar(name: user.displayName, size: 96),
                  const SizedBox(height: AppSpacing.l),
                  Text(
                    user.displayName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      user.id,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimaryContainer,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.huge),
            _ProfileRow(
              icon: Icons.badge_rounded,
              label: 'FriendZChat ID',
              value: user.id,
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: user.id));
                if (!context.mounted) return;
                context.showSnack('ID copied');
              },
            ),
            if (user.phoneNumber != null)
              _ProfileRow(
                icon: Icons.phone_rounded,
                label: 'Phone',
                value: user.phoneNumber!,
              ),
            if (user.email != null)
              _ProfileRow(
                icon: Icons.alternate_email_rounded,
                label: 'Email',
                value: user.email!,
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              icon: const Icon(Icons.ios_share_rounded),
              label: const Text('Share my ID'),
              onPressed: () => Share.share(
                'Add me on FriendZChat — my ID is ${user.id}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.s),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.content_copy_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}