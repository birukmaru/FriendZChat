/// Contact support screen.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class SettingsSupportScreen extends StatelessWidget {
  const SettingsSupportScreen({super.key});

  static final Uri _supportEmail = Uri(
    scheme: 'mailto',
    path: 'support@friendzchat.example.com',
    queryParameters: {'subject': 'FriendZChat support'},
  );

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.l,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SUPPORT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Reach our team',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Email support@friendzchat.example.com — we typically reply within one business day.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                onPressed: () => _openEmail(context),
                icon: Icons.mail_rounded,
                label: 'Open email draft',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEmail(BuildContext context) async {
    final ok = await launchUrl(_supportEmail);
    if (!ok && context.mounted) {
      context.showSnack(
        'No email app available — copy support@friendzchat.example.com',
        isError: true,
      );
    }
  }
}