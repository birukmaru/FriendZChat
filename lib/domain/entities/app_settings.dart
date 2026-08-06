/// Domain entity: persisted user settings.
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

enum AppLanguage { english, spanish, french, german, arabic }

extension AppLanguageX on AppLanguage {
  String get code => switch (this) {
        AppLanguage.english => 'en',
        AppLanguage.spanish => 'es',
        AppLanguage.french => 'fr',
        AppLanguage.german => 'de',
        AppLanguage.arabic => 'ar',
      };

  String get displayName => switch (this) {
        AppLanguage.english => 'English',
        AppLanguage.spanish => 'Español',
        AppLanguage.french => 'Français',
        AppLanguage.german => 'Deutsch',
        AppLanguage.arabic => 'العربية',
      };

  Locale get locale => Locale(code);
}

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.english,
    this.notificationsEnabled = true,
    this.registrationRemindersEnabled = true,
    this.tipsEnabled = true,
    this.updatesEnabled = true,
    this.biometricLockEnabled = false,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool notificationsEnabled;
  final bool registrationRemindersEnabled;
  final bool tipsEnabled;
  final bool updatesEnabled;
  final bool biometricLockEnabled;

  ThemeMode get materialThemeMode => switch (themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? notificationsEnabled,
    bool? registrationRemindersEnabled,
    bool? tipsEnabled,
    bool? updatesEnabled,
    bool? biometricLockEnabled,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        registrationRemindersEnabled:
            registrationRemindersEnabled ?? this.registrationRemindersEnabled,
        tipsEnabled: tipsEnabled ?? this.tipsEnabled,
        updatesEnabled: updatesEnabled ?? this.updatesEnabled,
        biometricLockEnabled:
            biometricLockEnabled ?? this.biometricLockEnabled,
      );

  @override
  List<Object?> get props => [
        themeMode,
        language,
        notificationsEnabled,
        registrationRemindersEnabled,
        tipsEnabled,
        updatesEnabled,
        biometricLockEnabled,
      ];
}