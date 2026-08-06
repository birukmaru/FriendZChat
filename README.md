# FriendZChat

> **Speak freely. Connect privately.**

A modern Flutter client for the FriendZChat telecom service. Reach any
registered user through a 6-digit ID — never your real number.

---

## Highlights

- **Privacy-first calling** — every call is routed through the carrier's
  private service. The other party never sees your real number.
- **Modern Material 3 design system** — Inter typography, tonal color
  palette seeded from teal, glass-morphic floating dock with a center
  "add" FAB, micro-animated onboarding.
- **Offline-capable** — contacts, history and notifications live on the
  device (Hive + flutter_secure_storage). No cloud round-trip required.
- **Pluggable call transport** — abstract `CallService` with a default
  dialer implementation; swap in SIP / VoIP / REST without UI changes.
- **Production-ready architecture** — Clean Architecture layers
  (presentation → domain ← data), Riverpod state, GoRouter with auth
  guards, Dio + interceptors, repository pattern, mock + real API
  implementations, Freezed DTOs.

---

## Features

| Feature | Status |
|---|---|
| Animated onboarding (3 pages) | ✅ |
| Registration via carrier (call + SMS) | ✅ |
| 6-digit FriendZChat ID with copy & share | ✅ |
| Quick call by ID with smart contact lookup | ✅ |
| Contacts CRUD (Hive-backed) | ✅ |
| Favourite contacts with home-screen widget | ✅ |
| Recent calls with swipe-to-delete | ✅ |
| Profile view & edit | ✅ |
| Notifications (5 kinds: reminder / tip / update / alert / marketing) | ✅ |
| Settings (theme, language, notifications) | ✅ |
| Privacy, Terms, FAQ, About, Help, Support | ✅ |
| Glass-morphic floating dock with center FAB | ✅ |
| Material 3 + dark mode + text-scale clamp | ✅ |
| Responsive content-width cap (tablet / desktop) | ✅ |
| Localization (EN, ES, FR, DE, AR) | ✅ |
| Secure storage of sensitive data | ✅ |
| SharedPreferences for non-sensitive settings | ✅ |
| Riverpod state management | ✅ |
| GoRouter navigation + auth / onboarding guards | ✅ |
| Dio HTTP with auth + retry interceptors | ✅ |
| Freezed + JSON Serializable models | ✅ |
| Repository pattern + GetIt DI | ✅ |
| Mock API for fully offline UI development | ✅ |
| Unit + widget + repository tests | ✅ |

---

## Screenshots

| Dashboard | Call | Contacts |
|---|---|---|
| Premium hero with ID, copy/share, quick-call | Quick-call ID entry + saved contacts | Grouped cards with avatar + call button |

| History | Settings | Onboarding |
|---|---|---|
| Grouped cards, swipe-to-delete | Stat-tile sections, danger variants | Animated 3-page intro with gradient orbs |

---

## Architecture

Clean Architecture with strict layer boundaries:

```
lib/
├── core/           # cross-cutting: theme, errors, constants, router, network, storage
├── data/           # data sources + Freezed DTOs
├── domain/         # entities, abstract repositories, use cases
├── repository/     # concrete repository implementations
├── services/       # call / auth / contact / notification / api services
├── presentation/   # screens, providers (Riverpod), shared widgets
├── utils/          # logger, result type, extensions
├── dependency_injection/   # get_it-based container
├── theme/          # colours, typography, dimensions, theme builder
├── app.dart        # MaterialApp.router wiring
└── main.dart       # bootstrap
```

**Layer rule:** `presentation → domain ← data/repository ← services → core`.
Domain knows nothing about Flutter, the network, or storage.

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for the full picture — performance,
testing, error model, etc.

---

## Quick start

```bash
# 1. Fetch packages
flutter pub get

# 2. Generate code (Freezed DTOs, JSON serializers, Riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# 3. Run
flutter run
```

### Requirements

- Flutter SDK `>= 3.22.0`
- Dart SDK `>= 3.4.0 < 4.0.0`
- Android Studio / Xcode for mobile builds

### Tests

```bash
flutter test
flutter test --coverage
```

### Mock vs real backend

By default the app uses an in-memory mock backend (`MockApiService`) so the
UI is fully functional without any server. Switch to the real backend via DI:

```dart
await configureDependencies(
  baseUrl: 'https://api.friendzchat.example.com',
  useMockApi: false,   // uses ApiServiceImpl(Dio)
);
```

---

## Design system

- **Typography** — Inter, custom scale with 14 named styles from
  `displayLarge` (56sp / -1.4 tracking) down to `labelSmall` (11sp / 0.5
  tracking). All weights, sizes and line-heights centralised in
  `lib/theme/app_text_styles.dart`.
- **Color** — Material 3 `ColorScheme.fromSeed(seed: teal)`, with a
  secondary `accent` indigo injected for premium surfaces. Light + dark
  variants share the same seed.
- **Spacing** — 11-step scale (`nano` through `giant`), 8-step radius
  scale, semantic elevation tokens, three-tier shadow scale.
- **Components** — `GradientOrb`, `StatTile`, `PageHeader`, `PageScaffold`,
  `FloatingNavDock`, `PrimaryButton` (4 variants), `EmptyStateView`,
  `ErrorStateView`, `ContactAvatar`, `ShimmerBox`.

Every screen consumes these — no ad-hoc styling.

---

## Pluggable call transport

`CallService` is the seam. Swap the implementation in
`lib/dependency_injection/injection.dart`:

```dart
getIt.registerLazySingleton<CallService>(() => SipCallService());
```

The default `DialerCallService` formats the destination as
`8776<userId>` and hands off to the system dialer via `tel:`.

---

## Security

- `flutter_secure_storage` for the user ID, auth token and any PII.
- No secrets in source — environment-specific config lives in
  `--dart-define` builds.
- ProGuard / R8 enabled in release (`isMinifyEnabled = true`).
- SSL pinning hooks exposed via `installCertificatePinning`.
- Crash-reporting hook in `AppLogger.e`.

---

## Conventions

- 100% null-safety.
- Lints live in `analysis_options.yaml` (strict).
- Repositories return `Result<T>` rather than throwing.
- Errors use the sealed `Failure` hierarchy.
- DTOs use Freezed; entities are immutable `Equatable` classes.
- All UI strings live in source — add localization via ARB files in
  `lib/l10n/`.

---

## Release checklist

1. `dart run build_runner build --delete-conflicting-outputs`
2. `flutter analyze`
3. `flutter test`
4. Bump `version` in `pubspec.yaml`.
5. **Android** — configure signing in `android/key.properties`.
6. **iOS** — configure signing in Xcode, update `CFBundleDisplayName`.
7. `flutter build appbundle --release`
8. `flutter build ipa --release`

---

## Documentation

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — layering, contracts, performance, testing.
- [`API.md`](API.md) — REST endpoints the client expects.
- [`SETUP.md`](SETUP.md) — environment setup walkthrough.
- [`CHANGELOG.md`](CHANGELOG.md) — release notes.
- `assets/data/mock_data.json` — sample data used by the mock backend.

---

## License

Proprietary. © FriendZChat. All rights reserved.