/// FriendZChat — entry point.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/app.dart';
import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/theme/app_text_styles.dart';
import 'package:friendzchat/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  AppTextStyles.init();
  await configureDependencies();

  FlutterError.onError = (details) {
    AppLogger.e(
      'Uncaught Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  runApp(const ProviderScope(child: FriendZChatApp()));
}