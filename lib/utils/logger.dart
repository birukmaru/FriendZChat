/// Lightweight logging utility used across the app.
///
/// Wraps the `logger` package so that the entire app uses one consistent
/// configuration and one place to wire up crash reporters / remote sinks
/// later.
library;

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract final class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: false,
      printTime: false,
    ),
    level: kReleaseMode ? Level.warning : Level.trace,
  );

  /// Log a fine-grained diagnostic event — only in debug builds.
  static void t(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.t(message, error: error, stackTrace: stackTrace);

  /// Log a debug event.
  static void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  /// Log an informational event.
  static void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  /// Log a warning — used for recoverable issues.
  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    developer.log(message, name: 'private_call.warning', error: error, stackTrace: stackTrace);
  }

  /// Log an error — for unexpected exceptions and crashes.
  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(message, name: 'private_call.error', error: error, stackTrace: stackTrace);
    // Hook for crash reporting — wire Crashlytics/Sentry here.
    // NOTE: Do NOT call FlutterError.reportError here. The app installs a
    // custom FlutterError.onError handler that forwards to AppLogger.e, so
    // calling reportError from inside the logger creates an infinite loop.
  }
}