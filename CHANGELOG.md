# Changelog

All notable changes to **FriendZChat** are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-08-03

### Added
- Initial production-ready release.
- Clean architecture (core / data / domain / repository / services / presentation).
- Material 3 theme with light + dark modes, Inter (Google Fonts), custom tokens.
- Onboarding (5 animated pages).
- Registration screen with the 8776 call/SMS helper.
- Login / OTP flow (mock + REST-ready).
- Home dashboard with ID copy / share / QR.
- Quick-call screen — type a 6-digit ID, dial `8776 + ID`.
- Contacts CRUD backed by Hive, with favourites + search.
- Call history with swipe-to-delete + clear all.
- Profile view + edit screen.
- QR generation (`qr_flutter`) and scanning (`mobile_scanner`).
- In-app notifications list.
- Settings (theme, language, notifications, sign-out, support, FAQ, legal).
- Riverpod state management, GoRouter navigation, Dio HTTP with retries.
- Secure storage (keychain / keystore), SharedPreferences, Hive cache.
- Pluggable call transport (`DialerCallService` / `SipCallService` / `VoipCallService` / `RestCallService`).
- Mock API for development.
- Unit, widget, repository, and smoke integration tests.
- Android: ProGuard / R8, signing config, permission manifest.
- iOS: Info.plist with camera / contacts / mic descriptions, deep link scheme.
- Documentation: README, ARCHITECTURE, API, CHANGELOG.

### Security
- All PII (user ID, token, nickname, phone) routed through secure storage.
- No secrets in source.
- R8 + resource shrinking enabled in release builds.
- Crash-reporting hook in `AppLogger.e`.