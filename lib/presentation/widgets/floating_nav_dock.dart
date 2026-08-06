/// Glassy pill bottom navigation dock with a center "add" FAB.
///
/// 5 slots total: 2 nav items, the center FAB, then 2 more nav items.
/// The FAB sits ABOVE the dock baseline (bottom margin) to give the
/// "floating button out of a rail" feel without using a real FAB —
/// the rail itself is a custom Row inside a `BackdropFilter`-blurred
/// pill so we can style it freely.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:friendzchat/core/strings/strings.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

/// A single nav slot in the [FloatingNavDock].
class NavSlot {
  const NavSlot({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class FloatingNavDock extends StatelessWidget {
  const FloatingNavDock({
    super.key,
    required this.slots,
    required this.selectedIndex,
    required this.onTap,
    required this.onAddPressed,
    this.fabIcon = Icons.add_rounded,
  });

  /// 4 nav slots — order is [left-1, left-2, right-1, right-2].
  /// The center FAB sits between index 1 and index 2.
  final List<NavSlot> slots;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;
  final IconData fabIcon;

  @override
  Widget build(BuildContext context) {
    assert(slots.length == 4, 'FloatingNavDock expects exactly 4 slots');
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.l,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DockItem(
                  slot: slots[0],
                  selected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                _DockItem(
                  slot: slots[1],
                  selected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
                _CenterFab(
                  icon: fabIcon,
                  onPressed: onAddPressed,
                  color: scheme.primary,
                ),
                _DockItem(
                  slot: slots[2],
                  selected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
                _DockItem(
                  slot: slots[3],
                  selected: selectedIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final NavSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? slot.selectedIcon : slot.icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                context.strings[slot.label],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  const _CenterFab({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.only(bottom: AppSpacing.l),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}