# FriendZChat — Architecture

This document describes the architecture of the **FriendZChat** Flutter
application. It complements `README.md` with deeper detail on layering,
contracts, and operational concerns.

## Goals

1. **Replaceable backend.** The UI must not depend on any concrete API
   client. Swapping `MockApiService` for `ApiServiceImpl(Dio)` happens in
   a single line of DI.
2. **Replaceable call transport.** Today the app launches the system
   dialer with the formatted number. The same `CallService` contract is
   also implemented by `SipCallService`, `VoipCallService`, and
   `RestCallService` — switching is one DI line.
3. **100% null-safe, 100% tested business logic.** Domain entities,
   use-cases, repositories, and DTO conversions are covered by unit
   tests. Shared widgets have widget tests. End-to-end smoke tests are
   under `test/integration/`.
4. **Privacy-by-default.** Sensitive data lives in `flutter_secure_storage`.
   The app never logs user IDs or contact details.

---

## Layering

```
┌───────────────────────────┐
│ Presentation              │   Screens, providers, widgets
└─────────────┬─────────────┘
              │
┌─────────────▼─────────────┐
│ Use cases / Domain        │   Pure Dart. No Flutter import.
└─────────────┬─────────────┘
              │
┌─────────────▼─────────────┐
│ Repositories              │   Concrete impls, depends on services + data
└─────────────┬─────────────┘
              │
┌─────────────▼─────────────┐
│ Data sources              │   Local (Hive) + remote (Dio / MockApiService)
└─────────────┬─────────────┘
              │
┌─────────────▼─────────────┐
│ Services / Core           │   Dio, secure storage, connectivity, logger
└───────────────────────────┘
```

The Domain layer has **zero** Flutter imports so it can be unit-tested in
plain Dart.

---

## State management

We use **Riverpod** exclusively. The shape of the dependency graph:

| Provider | Purpose |
|---|---|
| `prefsStateProvider` | Snapshot of theme / locale / onboarding flag |
| `authStateProvider` | Current user, registration status |
| `contactsProvider` | List of saved contacts |
| `historyProvider` | Call history |
| `notificationsProvider` | In-app notifications |
| `contactRepositoryProvider` | DI accessor for repositories |

`Notifier`s call the repositories, never the data sources directly.

---

## Navigation

`GoRouter` with three layers of guards:

1. **Splash** — initial location, decides where to go.
2. **Onboarding** — first launch only.
3. **Auth** — `register` / `login` if no user is stored.
4. **Main** — home / settings / profile / etc.

`RouterRefreshNotifier` listens to Riverpod state changes and re-runs the
guards, so signing out sends the user back to `register`.

---

## Result type & error pipeline

Repositories return `Result<T>` instead of throwing:

```dart
final Result<List<Contact>> res = await repo.getContacts();
res.when(
  onSuccess: (list) => render(list),
  onFailure: (f) => showSnack(f.message),
);
```

Internally they catch `AppException` and convert to a sealed `Failure`:

```
Failure
├── NetworkFailure
├── ServerFailure(statusCode, errorCode)
├── CacheFailure
├── AuthFailure
├── ValidationFailure(fieldErrors)
├── CancelledFailure
├── PermissionDeniedFailure
└── UnknownFailure
```

Errors surface uniformly in the UI via `ErrorStateView` or snackbars.

---

## Storage

| Layer | Backing store | Examples |
|---|---|---|
| Secure | `flutter_secure_storage` | user ID, auth token, nickname |
| Prefs | `shared_preferences` | theme, language, onboarding flag |
| Cache | `hive` | contacts, history, notifications |

---

## Call transport

`CallService` is the seam. Today `DialerCallService` builds
`8776<userId>` and launches `tel:`. Swap with `SipCallService`,
`VoipCallService`, or `RestCallService` via DI — the UI is unchanged.

```dart
abstract interface class CallService {
  String get name;
  Future<CallResult> placeCall({required String userId, String? displayName});
  Future<void> endCall(String callId);
}
```

---

## Theming

Material 3 throughout. `AppColors.seed` is the brand seed. `AppTheme`
produces light & dark themes that wire up `TextTheme`, `AppBarTheme`,
`InputDecorationTheme`, `CardThemeData`, etc. Inter (via Google Fonts)
is loaded once at boot via `AppTextStyles.init()`.

---

## Localization

`AppLanguage` enum drives both the UI language (via
`MaterialApp.supportedLocales`) and persistence. Adding a new language is
two lines: extend the enum, add it to the picker.

---

## Performance

- `const` constructors everywhere.
- `RepaintBoundary` not strictly needed because `shimmer` already
  isolates its draw.
- `Hive` is lazy and pagination-ready (`HistoryLocalDataSource.getAll`
  accepts `limit` + `offset`).
- `cached_network_image` for remote avatars.

---

## Testing

| Type | Path |
|---|---|
| Unit | `test/core/*`, `test/domain/*` |
| Widget | `test/widgets_test.dart`, `test/data/services_test.dart` |
| Repository | `test/data/repositories_test.dart` |
| Integration | `test/integration/app_smoke_test.dart` |

---

## Release / CI

`android/app/build.gradle.kts` enables R8 + resource shrinking for the
release variant. iOS uses standard Flutter signing. No CI workflow is
checked in to keep the project minimal by default — wire GitHub Actions
to:

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter analyze`
4. `flutter test`
5. `flutter build appbundle --release`
6. `flutter build ipa --release`

---

## Future work

- **SIP / VoIP** integrations (left as `SipCallService`, `VoipCallService`).
- **Firebase / REST** auth — wire `AuthService` to your provider of choice.
- **Cloud sync** for contacts and history (use the
  `UserRemoteDataSource` already in place).
- **Crashlytics / Sentry** hook — call site is `AppLogger.e`.
- **Analytics** — add `package:firebase_analytics` or your vendor of
  choice; provide a `AnalyticsService` and inject it.