/// Riverpod providers for app-wide preferences (theme, onboarding flag, etc.).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/storage/local_storage_service.dart';
import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';

/// Snapshot of the lightweight prefs we want widgets to react to.
class PrefsState {
  const PrefsState({
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.onboardingComplete,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool notificationsEnabled;
  final bool onboardingComplete;

  PrefsState copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? notificationsEnabled,
    bool? onboardingComplete,
  }) =>
      PrefsState(
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      );
}

/// Direct access to the underlying [LocalStorageService].
final localStorageProvider = Provider<LocalStorageService>(
  (ref) => getIt<LocalStorageService>(),
);

final settingsRepoProvider = Provider<SettingsRepository>(
  (ref) => getIt<SettingsRepository>(),
);

final _settingsProvider = FutureProvider<AppSettings>(
  (ref) async {
    final repo = ref.read(settingsRepoProvider);
    final res = await repo.load();
    return res.when(
      onSuccess: (s) => s,
      onFailure: (_) => const AppSettings(),
    );
  },
);

final prefsStateProvider =
    NotifierProvider<PrefsNotifier, PrefsState>(PrefsNotifier.new);

class PrefsNotifier extends Notifier<PrefsState> {
  @override
  PrefsState build() {
    // Load asynchronously; widgets that depend on this will rebuild when
    // settings arrive.
    _load();
    return const PrefsState(
      themeMode: AppThemeMode.system,
      language: AppLanguage.english,
      notificationsEnabled: true,
      onboardingComplete: false,
    );
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepoProvider);
    final res = await repo.load();
    final settings = res.when(
      onSuccess: (s) => s,
      onFailure: (_) => const AppSettings(),
    );
    final prefs = ref.read(localStorageProvider);
    final onboardingDone =
        (await prefs.getBool(AppConstants.onboardingCompleteKey)) ?? false;
    state = PrefsState(
      themeMode: settings.themeMode,
      language: settings.language,
      notificationsEnabled: settings.notificationsEnabled,
      onboardingComplete: onboardingDone,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await ref.read(settingsRepoProvider).setThemeMode(mode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await ref.read(settingsRepoProvider).setLanguage(language);
  }

  Future<void> markOnboardingComplete() async {
    final prefs = ref.read(localStorageProvider);
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);
    state = state.copyWith(onboardingComplete: true);
  }

  Future<void> resetOnboarding() async {
    final prefs = ref.read(localStorageProvider);
    await prefs.setBool(AppConstants.onboardingCompleteKey, false);
    state = state.copyWith(onboardingComplete: false);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    // Persist through the settings repository so the toggle survives
    // an app restart.
    await ref.read(settingsRepoProvider).update(
          AppSettings(
            themeMode: state.themeMode,
            language: state.language,
            notificationsEnabled: enabled,
          ),
        );
  }
}

ThemeMode materialThemeMode(AppThemeMode mode) => switch (mode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };