/// Layout tokens — spacing, radii, durations, breakpoints, elevations.
library;

import 'package:flutter/material.dart';

abstract final class AppSpacing {
  AppSpacing._();
  static const double nano = 2;
  static const double micro = 6;
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
  static const double giant = 64;
}

abstract final class AppRadius {
  AppRadius._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double pill = 999;
}

abstract final class AppDurations {
  AppDurations._();
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration short = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration long = Duration(milliseconds: 520);
  static const Duration extraLong = Duration(milliseconds: 900);
}

abstract final class AppElevation {
  AppElevation._();
  static const double flat = 0;
  static const double raised = 1;
  static const double overlay = 4;
  static const double sheet = 8;
  static const double dialog = 12;
}

/// Three-step semantic shadow.  Use [ElevatedCard.shadow] for consistent
/// drop-shadow rendering across light/dark.
class AppShadows {
  const AppShadows._();
  static const List<BoxShadow> sm = [
    BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Color(0x14000000)),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(blurRadius: 16, offset: Offset(0, 6), color: Color(0x14000000)),
    BoxShadow(blurRadius: 4, offset: Offset(0, 1), color: Color(0x08000000)),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(blurRadius: 32, offset: Offset(0, 16), color: Color(0x18000000)),
    BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Color(0x0A000000)),
  ];
}

abstract final class AppBreakpoints {
  AppBreakpoints._();
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Convenience helper — true if [width] is a tablet-class layout.
bool isTabletLayout(double width) => width >= AppBreakpoints.tablet;

/// Returns a layout-aware max content width (caps very wide layouts).
double contentMaxWidth(double available) {
  if (available >= AppBreakpoints.desktop) return 720;
  if (available >= AppBreakpoints.tablet) return 600;
  return available;
}

/// Returns the standard horizontal gutter for a given width.
double horizontalGutter(double width) =>
    width >= AppBreakpoints.tablet ? AppSpacing.xxxl : AppSpacing.l;