# Assets

Place your image assets here.

## Recommended structure

```
assets/
├── images/
│   ├── splash_logo.png          # 1024x1024, used by flutter_native_splash
│   ├── app_icon.png             # 1024x1024 master app icon
│   ├── illustrations/
│   │   ├── empty_contacts.svg
│   │   ├── empty_history.svg
│   │   ├── empty_notifications.svg
│   │   ├── onboarding_privacy.svg
│   │   └── onboarding_how_it_works.svg
│   └── icons/
│       ├── ic_logo.svg
│       └── ic_shield.svg
├── animations/
│   └── loading.riv              # Optional Rive or Lottie files
├── data/
│   └── mock_data.json           # Demo data
└── fonts/
    └── Inter-*.ttf              # Optional — Google Fonts is preferred.
```

The project ships with placeholder directories only; drop the real files
in here.  If you don't have splash/app icons yet, the splash screen will
fall back to a procedurally drawn shield icon.