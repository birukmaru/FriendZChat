/// GoRouter configuration for FriendZChat.
///
/// One central declaration of routes + guards so screens can stay focused
/// on UI rather than navigation plumbing.
///
/// The router is exposed via [appRouterProvider], a Riverpod Provider. It
/// is created **once** for the lifetime of the app — rebuilding it on
/// every prefs change (theme, language) would reset the navigation back
/// to the splash because GoRouter navigates a freshly built router to
/// its `initialLocation`. The Provider body uses `ref.read` and
/// `ref.listen` (legal inside a Provider) instead of `ref.watch`, so it
/// never re-evaluates after first build.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';
import 'package:friendzchat/presentation/screens/call/call_screen.dart';
import 'package:friendzchat/presentation/screens/contacts/contact_detail_screen.dart';
import 'package:friendzchat/presentation/screens/contacts/contacts_add_screen.dart';
import 'package:friendzchat/presentation/screens/contacts/contacts_screen.dart';
import 'package:friendzchat/presentation/screens/history/history_screen.dart';
import 'package:friendzchat/presentation/screens/home/home_screen.dart';
import 'package:friendzchat/presentation/screens/notifications/notifications_screen.dart';
import 'package:friendzchat/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:friendzchat/presentation/screens/profile/profile_edit_screen.dart';
import 'package:friendzchat/presentation/screens/profile/profile_screen.dart';
import 'package:friendzchat/presentation/screens/registration/login_screen.dart';
import 'package:friendzchat/presentation/screens/registration/register_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_about_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_faq_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_help_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_language_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_privacy_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_support_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_terms_screen.dart';
import 'package:friendzchat/presentation/screens/settings/settings_screen.dart';
import 'package:friendzchat/presentation/screens/splash/splash_screen.dart';

/// The app's single [GoRouter] instance. Created once and kept alive for
/// the lifetime of the [ProviderScope]. Watch this in `app.dart` instead
/// of constructing a fresh router on every build.
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterRefreshNotifier(ref);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      // Use ref.read here — we don't want the Provider body to depend on
      // these providers and re-run; we only need their *current* value
      // each time the redirect is evaluated.
      final auth = ref.read(authStateProvider);
      final prefs = ref.read(prefsStateProvider);
      final loc = state.matchedLocation;

      // Allow splash to do its work.
      if (loc == AppRoutes.splash) return null;

      // Onboarding gate.
      if (!prefs.onboardingComplete && loc != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (prefs.onboardingComplete && loc == AppRoutes.onboarding) {
        return AppRoutes.register;
      }

      // Auth gate.
      final isAuthRoute = loc == AppRoutes.register || loc == AppRoutes.login;
      if (!auth.isRegistered && !isAuthRoute && prefs.onboardingComplete) {
        return AppRoutes.register;
      }
      if (auth.isRegistered && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'contacts',
            builder: (_, __) => const ContactsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const ContactsAddScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    ContactDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'history',
            builder: (_, __) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (_, __) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'language',
                builder: (_, __) => const SettingsLanguageScreen(),
              ),
              GoRoute(
                path: 'about',
                builder: (_, __) => const SettingsAboutScreen(),
              ),
              GoRoute(
                path: 'privacy',
                builder: (_, __) => const SettingsPrivacyScreen(),
              ),
              GoRoute(
                path: 'terms',
                builder: (_, __) => const SettingsTermsScreen(),
              ),
              GoRoute(
                path: 'help',
                builder: (_, __) => const SettingsHelpScreen(),
              ),
              GoRoute(
                path: 'support',
                builder: (_, __) => const SettingsSupportScreen(),
              ),
              GoRoute(
                path: 'faq',
                builder: (_, __) => const SettingsFaqScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'profile',
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, __) => const ProfileEditScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'notifications',
            builder: (_, __) => const NotificationsScreen(),
          ),
        ],
      ),
      // Call screen accepts an optional userId — two explicit routes cover
      // both the manual-entry case (`/call`) and the direct-call case
      // (`/call/<userId>`) without relying on optional-path-param syntax.
      GoRoute(
        path: '/call',
        builder: (_, __) => const CallScreen(),
      ),
      GoRoute(
        path: '/call/:userId',
        builder: (_, state) =>
            CallScreen(userId: state.pathParameters['userId']!),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );

  // Ensure the router and its notifier are disposed when the provider
  // scope tears down (i.e. when the whole app shuts down).
  ref.onDispose(router.dispose);

  return router;
});

/// Bridge that re-evaluates the router's redirect whenever auth or
/// onboarding state changes.
///
/// [Ref] is the Riverpod base class accepted by both [Provider] bodies
/// and [Notifier] implementations, so the same notifier works whether
/// it's instantiated from a Provider body (legal) or from a WidgetRef's
/// build method (illegal — that's the bug we're fixing).
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(prefsStateProvider, (_, __) => notifyListeners());
  }
}