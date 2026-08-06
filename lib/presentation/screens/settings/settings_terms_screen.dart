/// Terms of service screen.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class SettingsTermsScreen extends StatelessWidget {
  const SettingsTermsScreen({super.key});

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
              'Terms of service',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'The agreement between you and FriendZChat.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _TermsCard(
              title: 'Acceptable use',
              body:
                  'Use FriendZChat only for lawful purposes and in accordance with your local telecom regulations.',
            ),
            const _TermsCard(
              title: 'Service availability',
              body:
                  'The service is provided as-is, without warranty. Updates may pause availability without notice.',
            ),
            const _TermsCard(
              title: 'Liability',
              body:
                  'We are not liable for any indirect, incidental, or consequential damages arising from use of the service.',
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.title, required this.body});
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