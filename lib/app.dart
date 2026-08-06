/// Top-level MaterialApp.router wiring.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_router.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';
import 'package:friendzchat/theme/app_text_styles.dart';
import 'package:friendzchat/theme/app_theme.dart';

class FriendZChatApp extends ConsumerStatefulWidget {
  const FriendZChatApp({super.key, this.initialLocale});

  /// Optional initial locale override (used for tests).
  final Locale? initialLocale;

  @override
  ConsumerState<FriendZChatApp> createState() => _FriendZChatAppState();
}

class _FriendZChatAppState extends ConsumerState<FriendZChatApp> {
  // Cache the router so it isn't recreated on every prefs change.
  // Without this, switching language or theme rebuilds the GoRouter
  // and MaterialApp.router navigates back to the splash because the
  // new router's initialLocation is `/`.
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final prefs = ref.watch(prefsStateProvider);

    // Swap in the Amharic text theme when Amharic is the active language,
    // so Ge'ez script renders via Noto Sans Ethiopic. Inter stays for
    // Latin fallback.
    final baseLight = AppTheme.light();
    final baseDark = AppTheme.dark();
    final isAmharic = prefs.language == AppLanguage.amharic;
    final light = isAmharic
        ? baseLight.copyWith(textTheme: AppTextStyles.amharicTextTheme)
        : baseLight;
    final dark = isAmharic
        ? baseDark.copyWith(textTheme: AppTextStyles.amharicTextTheme)
        : baseDark;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FriendZChat',
      theme: light,
      darkTheme: dark,
      themeMode: materialThemeMode(prefs.themeMode),
      locale: widget.initialLocale ?? prefs.language.locale,
      supportedLocales: AppLanguage.values
          .map((l) => l.locale)
          .toList(growable: false),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.3,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}