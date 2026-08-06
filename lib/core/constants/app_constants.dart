/// Global application constants.
///
/// Centralized constants so no magic numbers live in feature code.
library;

/// Static, app-wide identifiers and configuration.
abstract final class AppConstants {
  AppConstants._();

  /// Internal service short-code used for the private telecom service.
  /// All outbound user calls are prefixed with this number.
  static const String serviceShortCode = '8776';

  /// Friendly name shown in onboarding and help text.
  static const String serviceName = 'FriendZChat';

  /// Tagline displayed in onboarding splash.
  static const String tagline = 'Speak freely. Connect privately.';

  /// Stored key for the locally-registered user ID.
  static const String userIdStorageKey = 'private_call.user_id';

  /// Stored key for the auth/access token.
  static const String authTokenStorageKey = 'private_call.auth_token';

  /// Preference key for theme mode.
  static const String themeModePrefsKey = 'private_call.theme_mode';

  /// Preference key for locale.
  static const String localePrefsKey = 'private_call.locale';

  /// Preference key for first-launch onboarding.
  static const String onboardingCompleteKey = 'private_call.onboarding_done';

  /// Preference key for notifications enabled.
  static const String notificationsEnabledKey = 'private_call.notifications_enabled';

  /// Hive box for contacts.
  static const String contactsBox = 'contacts_box';

  /// Hive box for call history.
  static const String historyBox = 'history_box';

  /// Hive box for notifications.
  static const String notificationsBox = 'notifications_box';

  /// Hive box for settings.
  static const String settingsBox = 'settings_box';

  /// Default network base URL — replace with real backend when ready.
  static const String defaultBaseUrl = 'https://api.privatecall.example.com';

  /// API version prefix.
  static const String apiVersion = 'v1';

  /// Request timeout for normal HTTP calls.
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Connection timeout (lower).
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Connect retries on transient failure.
  static const int maxRetries = 3;
}

/// API endpoint catalogue (relative to [baseUrl]).
abstract final class ApiEndpoints {
  ApiEndpoints._();

  static const String register = '/register';
  static const String verify = '/verify';
  static const String call = '/call';
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String contacts = '/contacts';
  static const String contactById = '/contacts'; // + /{id}
  static const String history = '/history';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String logout = '/auth/logout';
  static const String otp = '/auth/otp';
  static const String refreshToken = '/auth/refresh';
}