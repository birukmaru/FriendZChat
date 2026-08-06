/// Privacy policy screen.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class SettingsPrivacyScreen extends StatelessWidget {
  const SettingsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.l,
          ),
          children: [
            Text(
              'LEGAL',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.primary,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Privacy policy',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Last updated today. Plain-English summary of how we handle your data.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _PolicyCard(
              title: 'Your privacy matters',
              body:
                  'FriendZChat is designed to keep your data on your device. We do not sell, share, or expose your contacts or call history.',
            ),
            const _PolicyCard(
              title: 'What we store',
              body:
                  'Your FriendZChat ID, profile details, contacts and history are stored locally in encrypted storage. We only contact our backend for verification and updates.',
            ),
            const _PolicyCard(
              title: 'Permissions',
              body:
                  'Contacts for address-book sync and notifications for reminders. None of these permissions are used for anything else.',
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}