/// Shared widget: primary call-to-action button with subtle press feedback.
///
/// Variants:
///   [PrimaryButtonVariant.gradient] — gradient brand button (default)
///   [PrimaryButtonVariant.filled]   — Material 3 filled
///   [PrimaryButtonVariant.tonal]    — Material 3 tonal
///   [PrimaryButtonVariant.outline]  — Material 3 outlined
library;

import 'package:flutter/material.dart';

import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

enum PrimaryButtonVariant {
  gradient,
  filled,
  tonal,
  outline,
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.variant = PrimaryButtonVariant.gradient,
    this.gradient = AppColors.primaryGradient,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;
  final PrimaryButtonVariant variant;
  final Gradient gradient;
  final bool expand;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  bool get _disabled => widget.onPressed == null || widget.busy;

  @override
  Widget build(BuildContext context) {
    final child = _build(context);
    final sized = SizedBox(
      width: widget.expand ? double.infinity : null,
      height: 56,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        child: child,
      ),
    );
    return GestureDetector(
      onTapDown: (_) {
        if (!_disabled) setState(() => _pressed = true);
      },
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: sized,
    );
  }

  Widget _build(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.variant) {
      case PrimaryButtonVariant.filled:
        return _core(
          theme: theme,
          child: _label(theme, color: theme.colorScheme.onPrimary),
          onTap: () => widget.onPressed?.call(),
        );
      case PrimaryButtonVariant.tonal:
        return _core(
          theme: theme,
          background: theme.colorScheme.secondaryContainer,
          child: _label(theme, color: theme.colorScheme.onSecondaryContainer),
          onTap: () => widget.onPressed?.call(),
        );
      case PrimaryButtonVariant.outline:
        return _core(
          theme: theme,
          background: Colors.transparent,
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 1.4,
          ),
          child: _label(theme, color: theme.colorScheme.primary),
          onTap: () => widget.onPressed?.call(),
        );
      case PrimaryButtonVariant.gradient:
        return _core(
          theme: theme,
          gradient: _disabled ? null : widget.gradient,
          background: _disabled
              ? theme.colorScheme.surfaceContainerHighest
              : null,
          child: _label(theme, color: Colors.white),
          onTap: () => widget.onPressed?.call(),
        );
    }
  }

  Widget _core({
    required ThemeData theme,
    required Widget child,
    required VoidCallback onTap,
    Gradient? gradient,
    Color? background,
    BoxBorder? border,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: border,
        boxShadow: (gradient != null && !_disabled)
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.m),
          onTap: _disabled ? null : onTap,
          child: Center(
            child: widget.busy
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: _disabled
                          ? theme.colorScheme.onSurfaceVariant
                          : Colors.white,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }

  Widget _label(ThemeData theme, {required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.s),
        ],
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}