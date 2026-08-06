/// Typography scale.
///
/// Google Fonts `Inter` is loaded once via [AppTextStyles.init] then applied
/// through `Theme.of(context).textTheme`.  Direct access is provided for
/// places that need a specific style outside the theme.
///
/// Hierarchy (large → small):
///   displayLarge  → 56 / 64   hero / splash
///   displayMedium → 44 / 52   hero on cards
///   displaySmall  → 36 / 44   onboarding title
///   headlineLarge → 30 / 36   page title (AppBar)
///   headlineMedium→ 24 / 32   section title
///   headlineSmall → 20 / 28   card title
///   titleLarge    → 18 / 26   row title
///   titleMedium   → 16 / 24   list title / chip
///   titleSmall    → 14 / 20   meta
///   bodyLarge     → 16 / 24   primary body
///   bodyMedium    → 14 / 22   secondary body
///   bodySmall     → 13 / 20   helper / caption
///   labelLarge    → 14 / 20   button label
///   labelMedium   → 12 / 18   chip label
///   labelSmall    → 11 / 16   tag / overline
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static TextTheme? _cached;

  /// Call once at app start. Subsequent calls are no-ops.
  static void init() {
    _cached ??= _buildTextTheme();
  }

  /// Resolved text theme — falls back to a fresh build if [init] was skipped.
  static TextTheme get textTheme => _cached ??= _buildTextTheme();

  static TextTheme _buildTextTheme() {
    // GoogleFonts.interTextTheme() schedules a network fetch. If the device
    // is offline (or the font CDN is unreachable), the call returns a fallback
    // theme synchronously, but the network attempt surfaces as an unhandled
    // exception later. Disabling runtime fetching makes GoogleFonts use the
    // system font and skip the network call entirely on platforms where
    // Inter isn't bundled.
    GoogleFonts.config.allowRuntimeFetching = false;
    final base = GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    );

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 56,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 44,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 30,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 13,
        height: 1.45,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Eyebrow / overline — uppercase tracking used above titles.
  static TextStyle eyebrow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: scheme.primary,
          letterSpacing: 1.4,
        );
  }
}