# Setup

Step-by-step instructions for getting **FriendZChat** running locally
and preparing a release build.

## Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.22.0 |
| Dart SDK | ≥ 3.4.0 |
| Android Studio / SDK | 34 |
| Xcode | 15+ (iOS / macOS only) |
| CocoaPods | latest (iOS / macOS only) |

Confirm:

```bash
flutter doctor
```

## Install

```bash
git clone <repo>
cd friendzchat
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The first boot uses `MockApiService`, so no backend is required.

## Running with a real backend

Edit `lib/dependency_injection/injection.dart` and pass `useMockApi: false`
plus a base URL:

```dart
await configureDependencies(
  baseUrl: 'https://api.privatecall.example.com',
  useMockApi: false,
);
```

Or wire it to `--dart-define`:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.privatecall.example.com \
  --dart-define=USE_MOCK_API=false
```

(See the `lib/core/constants/app_constants.dart` keys for more options.)

## Android

- `android/key.properties` (git-ignored) holds signing credentials:

  ```
  storePassword=...
  keyPassword=...
  keyAlias=...
  storeFile=/abs/path/to/key.jks
  ```

- Generate a keystore:

  ```bash
  keytool -genkey -v -keystore ~/private-call.jks -keyalg RSA \
    -keysize 2048 -validity 10000 -alias privatecall
  ```

- Bundle:

  ```bash
  flutter build appbundle --release
  ```

## iOS

- Open `ios/Runner.xcworkspace`.
- Select the `Runner` target → Signing & Capabilities → pick your team.
- Update the bundle identifier to your reverse-domain (default
  `com.privatecall.app`).
- Archive via `Product → Archive`.

## macOS / Windows / Linux

The mobile and desktop targets share most of the code.  The `CallService`
defaults to the system dialer on every platform.

## Tests

```bash
flutter test
flutter test --coverage
```

Coverage report lands in `coverage/lcov.info`.

## Build flavours

Use `--flavour` and `--target` to ship staging/production variants:

```bash
flutter build appbundle --flavour production -t lib/main.dart
```

The provided `main.dart` is a single bootstrap entry; extend it with
flavour-specific config as needed.