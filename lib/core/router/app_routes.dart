/// Route catalogue — typed names for use across the app.
///
/// These strings MUST mirror the GoRoute declarations in `app_router.dart`.
/// They are nested under `/home` to keep the home shell mounted while
/// children navigate.
library;

abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';

  // Call screen — `userId` is optional (Quick Call enters it manually).
  static const String call = '/call';
  static const String callArgs = '/call/:userId';

  // Contacts (nested under home).
  static const String contacts = '/home/contacts';
  static const String contactsAdd = '/home/contacts/add';
  static const String contactDetail = '/home/contacts/:id';

  // History (nested under home).
  static const String history = '/home/history';

  // Settings (nested under home).
  static const String settings = '/home/settings';
  static const String settingsLanguage = '/home/settings/language';
  static const String settingsAbout = '/home/settings/about';
  static const String settingsPrivacy = '/home/settings/privacy';
  static const String settingsTerms = '/home/settings/terms';
  static const String settingsHelp = '/home/settings/help';
  static const String settingsSupport = '/home/settings/support';
  static const String settingsFaq = '/home/settings/faq';

  // Profile (nested under home).
  static const String profile = '/home/profile';
  static const String profileEdit = '/home/profile/edit';

  // Notifications (nested under home).
  static const String notifications = '/home/notifications';

  static String callTo(String userId) => '/call/$userId';
  static String contactDetailFor(String id) => '/home/contacts/$id';
}