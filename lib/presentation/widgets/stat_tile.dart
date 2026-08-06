/// Shared widget: settings / profile row with icon, label, value, optional
/// trailing chevron, and onTap.  Designed to match the `PageHeader` rhythm
/// and the new `AppRadius` / `AppSpacing` tokens.
library;

import 'package:flutter/material.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = danger ? scheme.error : scheme.onSurface;
    final iconColor = danger ? scheme.error : scheme.primary;
    final iconBg = danger
        ? scheme.errorContainer.withValues(alpha: 0.6)
        : scheme.primaryContainer;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.l),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: fg,
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
              if (value != null)
                Text(
                  value!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              if (trailing != null) trailing!,
              if (onTap != null && trailing == null) ...[
                const SizedBox(width: AppSpacing.s),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical gap sized with [AppSpacing] tokens.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(height: size, width: size);
}

/// Horizontal gap.
class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}