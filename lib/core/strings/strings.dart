/// Localization strings for English + Amharic.
///
/// Use `context.strings.keyName` (via the [StringsContextX] extension)
/// to access translated strings. Any key missing from the active
/// locale's map falls back to English, so partial translations degrade
/// gracefully.
///
/// Add new strings to [_en] (the canonical map) and, when ready, mirror
/// them in [_am]. No other files need touching.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';

class Strings {
  const Strings(this._values);

  final Map<String, String> _values;

  /// Lookup a string by [key]. Falls back to the key itself if missing
  /// from both locales (developer-visible during development).
  String get(String key) => _values[key] ?? key;

  /// Shortcut: `context.strings.appName`.
  String operator [](String key) => get(key);

  /// Build a [Strings] for the given language. Unknown languages fall
  /// back to English.
  static Strings of(AppLanguage lang) {
    final values = switch (lang) {
      AppLanguage.amharic => _am,
      AppLanguage.english => _en,
    };
    return Strings(values);
  }
}

extension StringsContextX on BuildContext {
  /// Translated strings for the current language preference.
  ///
  /// Reads the language live from [prefsStateProvider] so it rebuilds
  /// when the user switches language in Settings.
  Strings get strings {
    AppLanguage lang = AppLanguage.english;
    try {
      final container = ProviderScope.containerOf(this, listen: true);
      lang = container.read(prefsStateProvider).language;
    } catch (_) {
      // Provider not available (e.g. outside ProviderScope) — fall back.
    }
    return Strings.of(lang);
  }
}

// ─── Canonical English strings ─────────────────────────────────────────────
const Map<String, String> _en = {
  // App
  'app.name': 'FriendZChat',
  'app.tagline': 'Speak freely. Connect privately.',

  // Navigation
  'nav.home': 'Home',
  'nav.contacts': 'Contacts',
  'nav.history': 'History',
  'nav.settings': 'Settings',

  // Onboarding
  'onboarding.skip': 'Skip',
  'onboarding.continue': 'Continue',
  'onboarding.getStarted': 'Get started',
  'onboarding.eyebrow.welcome': 'Welcome',
  'onboarding.eyebrow.howItWorks': 'How it works',
  'onboarding.eyebrow.getStarted': 'Get started',
  'onboarding.title.welcome': 'Speak freely.\nConnect privately.',
  'onboarding.body.welcome':
      'Reach anyone on our telecom service with a 6-digit ID — no phone numbers shared, ever.',
  'onboarding.title.howItWorks': 'Your number stays yours',
  'onboarding.body.howItWorks':
      'Calls route through our dedicated service. The other person never sees your real number — and you never see theirs.',
  'onboarding.title.getStarted': 'Get your 6-digit ID',
  'onboarding.body.getStarted':
      'Call the service number, follow the prompts, then text OK. You\'ll receive your ID instantly.',

  // Registration
  'register.eyebrow': 'Set up account',
  'register.title': 'Get your ID',
  'register.subtitle':
      'Follow three quick steps to receive your 6-digit FriendZChat ID.',
  'register.step.call.title': 'Call the service number',
  'register.step.call.body': 'Dial the service number from your phone.',
  'register.step.call.action': 'Call now',
  'register.step.sms.title': 'Send "OK" to the service number',
  'register.step.sms.body':
      'Once the voice prompts finish, text OK to confirm registration.',
  'register.step.sms.action': 'Send SMS',
  'register.step.receive.title': 'Receive your ID',
  'register.step.receive.body':
      'The system will reply with a 6-digit ID. Enter it below — we\'ll keep it safe.',
  'register.section.id': 'Your 6-digit ID',
  'register.section.profile': 'Profile (optional)',
  'register.field.nickname': 'Nickname',
  'register.field.phone': 'Phone number',
  'register.field.continue': 'Continue',

  // Login
  'login.eyebrow': 'Welcome back',
  'login.title': 'Sign in to FriendZChat',
  'login.subtitle':
      'Enter your phone number and we\'ll send you a one-time code.',
  'login.field.phone': 'Phone number',
  'login.field.otp': 'One-time code',
  'login.button.send': 'Send OTP',
  'login.button.verify': 'Verify & continue',

  // Splash
  'splash.tagline': 'Speak freely. Connect privately.',

  // Settings — section headers
  'settings.eyebrow': 'Settings',
  'settings.title': 'Preferences',
  'settings.subtitle':
      'Tailor FriendZChat to match your style and habits.',
  'settings.section.profile': 'Profile',
  'settings.section.preferences': 'Preferences',
  'settings.section.support': 'Support',
  'settings.section.legal': 'Legal',
  'settings.section.language': 'Language',
  'settings.preferences.language.title': 'Language',
  'settings.preferences.language.subtitle':
      'Pick the language FriendZChat will use.',
  'settings.preferences.theme.title': 'Dark mode',
  'settings.preferences.theme.system': 'Match system',
  'settings.preferences.theme.light': 'Always light',
  'settings.preferences.theme.dark': 'Always dark',
  'settings.preferences.notifications.title': 'Notifications',
  'settings.preferences.notifications.subtitle':
      'In-app reminders, tips and updates',
  'settings.profile.view': 'View profile',
  'settings.profile.qr': 'My QR code',
  'settings.profile.share': 'Share my ID',
  'settings.signout': 'Sign out',
  'settings.signout.subtitle': 'You\'ll need your ID to sign back in',

  // Common actions
  'common.cancel': 'Cancel',
  'common.save': 'Save',
  'common.tryAgain': 'Try again',
  'common.copied': 'ID copied',
  'common.somethingWrong': 'Something went wrong',

  // Errors
  'error.invalidId': 'Enter a valid 6-digit FriendZChat ID',
  'error.noInternet': 'Could not launch the dialer',
  'error.noSmsApp': 'Could not launch the SMS app',
};

// ─── Amharic strings ───────────────────────────────────────────────────────
const Map<String, String> _am = {
  // App
  'app.name': 'ፍሬንድዝቻት',
  'app.tagline': 'ነጻን ይናገሩ። በመረጃ ጥበቃ ይገናኙ።',

  // Navigation
  'nav.home': 'መነሻ',
  'nav.contacts': 'አግኞች',
  'nav.history': 'ታሪክ',
  'nav.settings': 'ቅንብሮች',

  // Onboarding
  'onboarding.skip': 'ዝለል',
  'onboarding.continue': 'ቀጥል',
  'onboarding.getStarted': 'ጀምር',
  'onboarding.eyebrow.welcome': 'እንኳን ደህና መጡ',
  'onboarding.eyebrow.howItWorks': 'እንዴት ነው የሚሰራው',
  'onboarding.eyebrow.getStarted': 'ጀምር',
  'onboarding.title.welcome': 'ነጻን ይናገሩ።\nበመረጃ ጥበቃ ይገናኙ።',
  'onboarding.body.welcome':
      'በ6-አሃዝ መለያ ቁጥር ለማንኛውም የቴሌኮም አገልግሎት ተጠቃሚ ይደርሱ — ስልክ ቁጥር ሳይጋራ።',
  'onboarding.title.howItWorks': 'ቁጥርዎ ለእርስዎ ይቆያል',
  'onboarding.body.howItWorks':
      'ጥሪዎች በአገልግሎታችን ይመራሉ። ሌላኛው ሰው ትክክለኛውን ቁጥርዎን አያያይም — እና እርስዎም የእሱን አትመለከቱም።',
  'onboarding.title.getStarted': 'የ6-አሃዝ መለያ ቁጥርዎን ያግኙ',
  'onboarding.body.getStarted':
      'የአገልግሎት ቁጥርን ይደውሉ፣ መመሪያዎቹን ይከተሉ፣ ከዚያ OK ይላኩ። መለያዎን ወዲያውኑ ያገኛሉ።',

  // Registration
  'register.eyebrow': 'መለያ ያዘጋጁ',
  'register.title': 'መለያ ቁጥርዎን ያግኙ',
  'register.subtitle':
      'የ6-አሃዝ ፍሬንድዝቻት መለያ ለማግኘት ሶስት ቀላል እርምጃዎችን ይከተሉ።',
  'register.step.call.title': 'የአገልግሎት ቁጥርን ይደውሉ',
  'register.step.call.body': 'የአገልግሎት ቁጥርን ከስልክዎ ይደውሉ።',
  'register.step.call.action': 'አሁን ይደውሉ',
  'register.step.sms.title': '"OK" ወደ አገልግሎት ቁጥር ይላኩ',
  'register.step.sms.body':
      'የድምጽ መመሪያዎቹ ሲጠናቀቁ፣ ምዝገባን ለማረጋገጥ OK ይላኩ።',
  'register.step.sms.action': 'SMS ላክ',
  'register.step.receive.title': 'መለያዎን ይቀበሉ',
  'register.step.receive.body':
      'ስርዓቱ በ6-አሃዝ መለያ ይመልሳል። ከዚህ በታች ያስገቡ — በአስተማማኝ ያስቀምጠዋል።',
  'register.section.id': 'የ6-አሃዝ መለያዎ',
  'register.section.profile': 'መገለጫ (አማራጭ)',
  'register.field.nickname': 'ቅጽል ስም',
  'register.field.phone': 'ስልክ ቁጥር',
  'register.field.continue': 'ቀጥል',

  // Login
  'login.eyebrow': 'እንኳን ደህና መጡ',
  'login.title': 'ወደ ፍሬንድዝቻት ይግቡ',
  'login.subtitle':
      'የስልክ ቁጥርዎን ያስገቡ እና የአንድ ጊዜ ኮድ እንልክልዎታለን።',
  'login.field.phone': 'ስልክ ቁጥር',
  'login.field.otp': 'የአንድ ጊዜ ኮድ',
  'login.button.send': 'OTP ላክ',
  'login.button.verify': 'አረጋግጥ እና ቀጥል',

  // Splash
  'splash.tagline': 'ነጻን ይናገሩ። በመረጃ ጥበቃ ይገናኙ።',

  // Settings — section headers
  'settings.eyebrow': 'ቅንብሮች',
  'settings.title': 'ምርጫዎች',
  'settings.subtitle':
      'ፍሬንድዝቻትን ከእርስዎ ልምድ ጋር ያስማሙ።',
  'settings.section.profile': 'መገለጫ',
  'settings.section.preferences': 'ምርጫዎች',
  'settings.section.support': 'ድጋፍ',
  'settings.section.legal': 'ህጋዊ',
  'settings.section.language': 'ቋንቋ',
  'settings.preferences.language.title': 'ቋንቋ',
  'settings.preferences.language.subtitle':
      'ፍሬንድዝቻት የሚጠቀምበትን ቋንቋ ይምረጡ።',
  'settings.preferences.theme.title': 'ጨለማ ሁነታ',
  'settings.preferences.theme.system': 'ከስርዓት ጋር ይዛመዳል',
  'settings.preferences.theme.light': 'ሁልጊዜ ብርሃን',
  'settings.preferences.theme.dark': 'ሁልጊዜ ጨለማ',
  'settings.preferences.notifications.title': 'ማስታወቂያዎች',
  'settings.preferences.notifications.subtitle':
      'የመተግበሪያ ውስጥ ማስታወቂያዎች፣ ምክሮች እና ዝመናዎች',
  'settings.profile.view': 'መገለጫ ይመልከቱ',
  'settings.profile.qr': 'የእኔ QR ኮድ',
  'settings.profile.share': 'መለያዬን አጋራ',
  'settings.signout': 'ውጣ',
  'settings.signout.subtitle': 'ለመመለስ መለያ ቁጥርዎ ያስፈልጋል',

  // Common actions
  'common.cancel': 'ሰርዝ',
  'common.save': 'አስቀምጥ',
  'common.tryAgain': 'እንደገና ሞክር',
  'common.copied': 'መለያ ተቀዳቋል',
  'common.somethingWrong': 'የሆነ ችግር ተፈጥሯል',

  // Errors
  'error.invalidId': 'ትክክለኛ የ6-አሃዝ ፍሬንድዝቻት መለያ ያስገቡ',
  'error.noInternet': 'ዳይለር ሊከፈት አልቻለም',
  'error.noSmsApp': 'የSMS መተግበሪያ ሊከፈት አልቻለም',
};