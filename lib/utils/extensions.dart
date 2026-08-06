/// Shared extension methods for common types.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DateTime helpers — formatting & relative descriptions.
extension DateTimeX on DateTime {
  /// Format e.g. "Mon, 03 Aug 2026".
  String get formatted => DateFormat('EEE, dd MMM yyyy').format(this);

  /// Time e.g. "10:24 AM".
  String get timeFormatted => DateFormat('jm').format(this);

  /// Smart relative time — "just now", "5m ago", "yesterday", "03 Aug".
  String relative() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 5) return 'Just now';
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && now.day == day) {
      return '${diff.inHours}h ago';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day) {
      return 'Yesterday';
    }
    if (diff.inDays < 7) return DateFormat('EEE').format(this);
    return DateFormat('dd MMM').format(this);
  }
}

/// Duration helpers — call duration formatting.
extension DurationX on Duration {
  /// Format a call duration as `mm:ss` (or `h:mm:ss` if hours > 0).
  String get callDuration {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:$mStr:$sStr';
    }
    return '$mStr:$sStr';
  }
}

/// Context helpers for responsive design.
extension BuildContextX on BuildContext {
  /// Screen size in logical pixels.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// True when the current layout is tablet-class (>= 600 logical pixels).
  bool get isTablet => screenSize.shortestSide >= 600;

  /// True when the current orientation is landscape.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Padded safe-area height — convenient for full-screen layouts.
  double get safeHeight =>
      screenSize.height -
      MediaQuery.paddingOf(this).top -
      MediaQuery.paddingOf(this).bottom;

  /// Show a quick snackbar.
  void showSnack(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Numeric helpers.
extension NumDurationX on num {
  /// Convert to a [Duration] using seconds.
  Duration get seconds => Duration(milliseconds: (this * 1000).toInt());
  Duration get ms => Duration(milliseconds: toInt());
}

/// String helpers.
extension StringX on String {
  /// Capitalise first letter.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Truncate with ellipsis.
  String truncate(int max, {String suffix = '…'}) =>
      length <= max ? this : '${substring(0, max).trimRight()}$suffix';
}
