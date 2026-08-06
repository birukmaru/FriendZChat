/// Color tokens for the FriendZChat design system.
///
/// Each token resolves to a [Color] suitable for both Material 3
/// `ColorScheme` generation and direct use in widgets.
library;

import 'package:flutter/material.dart';

/// Brand-neutral palette tuned for an elegant, premium feel.
abstract final class AppColors {
  AppColors._();

  // ─── Brand seed (deep teal — privacy + premium) ─────────────────────────────
  /// Seed for Material 3 ColorScheme.  All on-brand colors derive from this.
  static const Color seed = Color(0xFF0E7C7B);

  /// Deep indigo accent — used for premium surfaces, hero gradients, FABs.
  static const Color accent = Color(0xFF6366F1);

  /// Premium hero gradient — used for splash and onboarding covers.
  static const Gradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E1B4B),
      Color(0xFF0E7C7B),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  /// Primary brand gradient — for buttons, chips, badges.
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0E7C7B),
      Color(0xFF17BEBB),
    ],
  );

  /// Indigo accent gradient — FABs, hero CTAs.
  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
    ],
  );

  /// Success / answered call gradient.
  static const Gradient callGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF22C55E),
      Color(0xFF15803D),
    ],
  );

  // ─── Functional colors ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ─── Light theme neutrals ───────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFF1F5F9);
  static const Color lightSurfaceVariant = Color(0xFFEFF3F6);
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightOnSurface = Color(0xFF111827);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  static const Color lightOutline = Color(0xFFE2E8F0);
  static const Color lightOutlineVariant = Color(0xFFEEF2F6);

  // ─── Dark theme neutrals ────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF020617);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkSurfaceMuted = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkOnBackground = Color(0xFFF8FAFC);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF334155);
  static const Color darkOutlineVariant = Color(0xFF1E293B);

  // ─── Elevation tints (subtle shadows) ───────────────────────────────────────
  static Color elevationLight = Colors.black.withValues(alpha: 0.04);
  static Color elevationLightStrong = Colors.black.withValues(alpha: 0.08);
  static Color elevationDark = Colors.black.withValues(alpha: 0.30);
  static Color elevationDarkStrong = Colors.black.withValues(alpha: 0.45);

  // ─── Glass / translucent ────────────────────────────────────────────────────
  static Color glassLight = Colors.white.withValues(alpha: 0.6);
  static Color glassDark = Colors.white.withValues(alpha: 0.06);
  static Color scrim = Colors.black.withValues(alpha: 0.55);
  static Color scrimStrong = Colors.black.withValues(alpha: 0.75);
}