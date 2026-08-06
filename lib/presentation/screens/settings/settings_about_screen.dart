/// About screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

class SettingsAboutScreen extends ConsumerStatefulWidget {
  const SettingsAboutScreen({super.key});

  @override
  ConsumerState<SettingsAboutScreen> createState() =>
      _SettingsAboutScreenState();
}

class _SettingsAboutScreenState extends ConsumerState<SettingsAboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      if (mounted) setState(() => _info = value);
    });
  }

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
                'ABOUT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'FriendZChat',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
              Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x400E7C7B),
                        blurRadius: 32,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.shield_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  'Speak freely.\nConnect privately.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'FriendZChat is a thin client for our telecom service. Your contacts, history and notifications stay on your device.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.huge),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.m,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Version ${_info?.version ?? "—"} (${_info?.buildNumber ?? "—"})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  '© ${DateTime.now().year} FriendZChat',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}